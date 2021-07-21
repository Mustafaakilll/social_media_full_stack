import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../app_navigation_cubit.dart';
import '../../loading_view.dart';
import '../../utils/storage_helper.dart';
import '../user_repository.dart';
import 'profile_bloc.dart';

class ProfileView extends StatelessWidget {
  ProfileView({Key? key}) : super(key: key);

  final _refreshController = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(context.read<UserRepository>()),
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is UserFetchedSuccessful) {
            return SmartRefresher(
                controller: _refreshController,
                onRefresh: () async {
                  var user = await StorageHelper().getData('user', 'auth');
                  user = user as Map;
                  final username = user['username'];
                  context.read<ProfileBloc>().add(FetchUser(username));
                  _refreshController.refreshCompleted();
                },
                child: _SuccessBody(user: state.user));
          } else if (state is UserFetchedFailure) {
            return Center(child: Text('${state.exception}'));
          } else {
            return const LoadingView();
          }
        },
      ),
    );
  }
}

class _SuccessBody extends StatelessWidget {
  const _SuccessBody({Key? key, this.user}) : super(key: key);

  final user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(user['username'], context),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _avatarImage(user['avatar']),
                    _userInfo(user),
                  ],
                ),
                const SizedBox(height: 10),
                _bio(user['bio'], user['isMe']),
                _editFollowButton(user['isMe']),
              ],
            ),
          ),
          const Divider(color: Colors.grey, thickness: 5),
          _postsView(user['posts']),
        ],
      ),
    );
  }

  Widget _editFollowButton(bool isMe) {
    return Row(
      children: <Widget>[
        const Spacer(),
        if (!isMe) ElevatedButton(onPressed: () {}, child: const Text('Follow')),
        if (isMe) ElevatedButton(onPressed: () {}, child: const Text('Edit profile')),
        const Spacer(),
      ],
    );
  }

  Widget _userInfo(user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(children: <Widget>[const Text('Posts'), Text('${user['postCount']}')]),
        const SizedBox(width: 12),
        Column(children: <Widget>[const Text('Following'), Text('${user['followingCount']}')]),
        const SizedBox(width: 12),
        Column(children: <Widget>[const Text('Followers'), Text('${user['followersCount']}')]),
      ],
    );
  }

  AppBar _appBar(String username, BuildContext context) {
    return AppBar(
      title: Text(username),
      actions: [
        IconButton(onPressed: () => context.read<AppNavigationCubit>().logOut(), icon: const Icon(Icons.logout))
      ],
    );
  }

  CircleAvatar _avatarImage(avatarUrl) {
    return CircleAvatar(radius: 44, foregroundImage: NetworkImage(avatarUrl));
  }

  Widget _postsView(List posts) {
    return Expanded(
      child: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 2),
        children: posts.map((e) {
          return Image.network(e['files'].first, fit: BoxFit.fill);
        }).toList(),
      ),
    );
  }

  Widget _bio(String bio, bool isMe) {
    late Widget bioInfo;

    if (bio.isEmpty && isMe) bioInfo = const Text("You didn't update your bio yet");
    if (bio.isEmpty && !isMe) bioInfo = const Text("This user didn't change his bio yet");
    return bioInfo;
  }
}
