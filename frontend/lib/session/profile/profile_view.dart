import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../app_navigation_cubit.dart';
import '../../loading_view.dart';
import '../../utils/context_extension.dart';
import '../../utils/image_url_cache.dart';
import '../edit_profile/edit_profile_view.dart';
import '../user_repository.dart';
import 'profile_bloc.dart';

class ProfileView extends StatelessWidget {
  ProfileView({Key? key, required this.username}) : super(key: key);

  late final String username;

  final _refreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(context.read<UserRepository>())..add(FetchUser(username)),
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is UserFetchedSuccessful) {
            return SmartRefresher(
                controller: _refreshController,
                onRefresh: () async {
                  context.read<ProfileBloc>().add(FetchUser(username));
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

class _SuccessBody extends StatefulWidget {
  _SuccessBody({Key? key, required this.user}) : super(key: key);

  final Map user;

  @override
  __SuccessBodyState createState() => __SuccessBodyState();
}

class __SuccessBodyState extends State<_SuccessBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(widget.user['username'], context, widget.user['isMe']),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _userInfo(),
                const SizedBox(height: 10),
                _bio(widget.user['bio']),
                _editFollowButton(),
              ],
            ),
          ),
          const Divider(color: Colors.grey, thickness: 5),
          _postsView(widget.user['posts']),
        ],
      ),
    );
  }

  AppBar _appBar(String username, BuildContext context, bool isMe) {
    return AppBar(
      title: Text(username),
      actions: [
        if (isMe)
          IconButton(onPressed: () => context.read<AppNavigationCubit>().logOut(), icon: const Icon(Icons.logout)),
      ],
    );
  }

  Widget _avatarImage(String userId) {
    return CircleAvatar(radius: 44, foregroundImage: CachedNetworkImageProvider(ImageUrlCache().cacheUrl[userId]));
  }

  Widget _userInfo() {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        final _state = state as UserFetchedSuccessful;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _avatarImage(_state.user['_id']),
            _spacerWidget(),
            Column(children: <Widget>[const Text('Posts'), Text('${_state.user['postCount']}')]),
            _spacerWidget(),
            GestureDetector(
                onTap: () => context.navigateToPage(_FollowersView(_state.user['followers'])),
                child: Column(children: <Widget>[const Text('Followers'), Text('${_state.user['followersCount']}')])),
            _spacerWidget(),
            GestureDetector(
                onTap: () => context.navigateToPage(_FollowingView(_state.user['following'])),
                child: Column(children: <Widget>[const Text('Following'), Text('${_state.user['followingCount']}')])),
            _spacerWidget(),
          ],
        );
      },
    );
  }

  Widget _bio(String bio) {
    return bio.isNotEmpty ? Text(bio) : Container();
  }

  Widget _editFollowButton() {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        final _state = state as UserFetchedSuccessful;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            if (!_state.user['isMe'] && !_state.user['isFollowing'])
              ElevatedButton(
                  onPressed: () {
                    context.read<UserRepository>().follow(_state.user['_id']);
                    setState(() {
                      _state.user['followersCount']++;
                      _state.user['isFollowing'] = true;
                    });
                  },
                  child: const Text('Follow')),
            if (!_state.user['isMe'] && _state.user['isFollowing'])
              ElevatedButton(
                  onPressed: () {
                    context.read<UserRepository>().unfollow(_state.user['_id']);
                    setState(() {
                      _state.user['followersCount']--;
                      _state.user['isFollowing'] = false;
                    });
                  },
                  child: const Text('Unfollow')),
            if (_state.user['isMe'])
              ElevatedButton(
                  onPressed: () async {
                    //TODO: LOOK HERE AND TRANSLATE IT TO CONTEXT EXTENSION
                    final newUser = await Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => EditProfileView(_state.user)));
                    setState(() {
                      // context.navigateToPage(EditProfileView(_state.user));
                      _state.user['bio'] = newUser['bio'];
                      _state.user['avatar'] = newUser['avatar'];
                    });
                  },
                  child: const Text('Edit profile'))
          ],
        );
      },
    );
  }

  Widget _postsView(List posts) {
    return Expanded(
      child: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 2),
        children: posts.map((e) {
          return CachedNetworkImage(imageUrl: e['files'].first, fit: BoxFit.fill);
        }).toList(),
      ),
    );
  }

  Spacer _spacerWidget() => const Spacer();
}

class _FollowersView extends StatelessWidget {
  const _FollowersView(this._followers, {Key? key}) : super(key: key);

  final List _followers;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(),
        Expanded(
          child: ListView.builder(
            itemCount: _followers.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                onTap: () => context.navigateToPage(ProfileView(username: _followers[index]['username'])),
                title: Text(_followers[index]['username']),
                leading: CircleAvatar(foregroundImage: NetworkImage(_followers[index]['avatar'])),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _FollowingView extends StatelessWidget {
  const _FollowingView(this._following, {Key? key}) : super(key: key);

  final List _following;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(),
        Expanded(
          child: ListView.builder(
            itemCount: _following.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                onTap: () => context.navigateToPage(ProfileView(username: _following[index]['username'])),
                title: Text(_following[index]['username']),
                leading: CircleAvatar(foregroundImage: NetworkImage(_following[index]['avatar'])),
              );
            },
          ),
        ),
      ],
    );
  }
}
