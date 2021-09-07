import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../app_navigation_cubit.dart';
import '../../loading_view.dart';
import '../../utils/storage_helper.dart';
import '../user_repository.dart';
import 'profile_bloc.dart';

class ProfileView extends StatelessWidget {
  ProfileView({Key? key, this.username}) : super(key: key);

  late final String? username;

  final _refreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
    if (username == null) {
      StorageHelper().getData('user', 'auth').then((value) => username = (value as Map)['username']);
    }
    return BlocProvider(
      create: (context) => ProfileBloc(context.read<UserRepository>())..add(FetchUser(username!)),
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is UserFetchedSuccessful) {
            return SmartRefresher(
                controller: _refreshController,
                onRefresh: () async {
                  context.read<ProfileBloc>().add(FetchUser(username!));
                  _refreshController.refreshCompleted();
                },
                child: _SuccessBody(user: state.user));
          } else if (state is UserFetchedFailure) {
            return _ErrorBody(state.exception);
          } else {
            return const LoadingView();
          }
        },
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody(this._exception, {Key? key}) : super(key: key);

  final Exception _exception;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Instagram User')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Something went wrong why don\'t you try again'),
            Text('$_exception'),
          ],
        ),
      ),
    );
  }
}

class _SuccessBody extends StatelessWidget {
  _SuccessBody({Key? key, required this.user}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Map user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _appBar(user['username'], context),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _userInfo(user),
                const SizedBox(height: 10),
                _bio(user['bio']),
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

  AppBar _appBar(String username, BuildContext context) {
    return AppBar(
      title: Text(username),
      actions: [
        IconButton(onPressed: () => context.read<AppNavigationCubit>().logOut(), icon: const Icon(Icons.logout)),
      ],
    );
  }

  Widget _avatarImage(avatarUrl) {
    return CircleAvatar(radius: 44, foregroundImage: NetworkImage(avatarUrl));
  }

  Widget _userInfo(user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _avatarImage(user['avatar']),
        _spacerWidget(),
        Column(children: <Widget>[const Text('Posts'), Text('${user['postCount']}')]),
        _spacerWidget(),
        Column(children: <Widget>[const Text('Following'), Text('${user['followingCount']}')]),
        _spacerWidget(),
        Column(children: <Widget>[const Text('Followers'), Text('${user['followersCount']}')]),
        _spacerWidget(),
      ],
    );
  }

  Widget _bio(String bio) {
    return bio.isNotEmpty ? Text(bio) : Container();
  }

  Widget _editFollowButton(bool isMe) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        if (!isMe) ElevatedButton(onPressed: () {}, child: const Text('Follow')),
        if (!isMe) ElevatedButton(onPressed: () {}, child: const Text('Message')),
        if (isMe) ElevatedButton(onPressed: () {}, child: const Text('Edit profile')),
      ],
    );
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

  Spacer _spacerWidget() => const Spacer();
}
