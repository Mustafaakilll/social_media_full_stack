import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../loading_view.dart';
import '../post_repository.dart';
import 'home_bloc.dart';
import 'home_navigator/home_navigation_cubit.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  //TODO: ADD FETCH IMAGEURL SINGLETON CLASS
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(context.read<PostRepository>()),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is PostLoadedFail) {
            return const _ErrorBody();
          } else if (state is PostLoadedSuccess) {
            return _SuccessBody(posts: state.posts);
          } else {
            return const LoadingView();
          }
        },
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Something went wrong'),
            const Text("Why don't you try again"),
          ],
        ),
      ),
    );
  }
}

class _SuccessBody extends StatefulWidget {
  _SuccessBody({Key? key, required this.posts}) : super(key: key);

  final List posts;

  @override
  __SuccessBodyState createState() => __SuccessBodyState();
}

class __SuccessBodyState extends State<_SuccessBody> {
  final _refreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: _appBar(),
      body: _refreshFeed(_size),
    );
  }

  Widget _refreshFeed(Size size) {
    return SmartRefresher(
      header: const ClassicHeader(),
      controller: _refreshController,
      enablePullDown: true,
      enablePullUp: false,
      onRefresh: () {
        context.read<HomeBloc>().add(GetPosts());
        _refreshController.refreshCompleted();
      },
      enableTwoLevel: true,
      child: ListView.builder(
        itemCount: widget.posts.length,
        itemBuilder: (BuildContext context, int index) {
          return _postCard(index, size);
        },
      ),
    );
  }

  Widget _postCard(int index, Size size) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _userInfoRow(widget.posts[index]),
              _postImage(widget.posts[index]['files'].first),
              Row(
                children: [
                  likeButton(index, widget.posts[index]['_id']),
                  _commentButton(
                      widget.posts[index]['_id'], widget.posts[index]['comments'], widget.posts[index]['user'])
                ],
              ),
              _postCaption(size.width, widget.posts[index]),
            ],
          ),
        );
      },
    );
  }

  Widget _commentButton(String postId, List comments, user) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () => context.read<HomeNavigationCubit>().showComments(postId, comments, user),
          child: const Icon(Icons.message),
        );
      },
    );
  }

  Widget _postCaption(double width, final post) {
    return Row(
      children: [
        SizedBox(width: width * .01),
        Text(post['user']['username'], style: const TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(width: width * .02),
        Text(post['caption']),
      ],
    );
  }

  Widget likeButton(int index, String postId) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return !widget.posts[index]['isLiked']
            ? IconButton(
                onPressed: () {
                  context.read<HomeBloc>().add(ToggleLike(postId));
                  //TODO: CHANGE SET STATE IF IT IS POSSIBLE
                  setState(() => widget.posts[index]['isLiked'] = !widget.posts[index]['isLiked']);
                },
                icon: const Icon(Icons.favorite_outline),
                padding: EdgeInsets.zero)
            : IconButton(
                onPressed: () {
                  context.read<HomeBloc>().add(ToggleLike(postId));
                  setState(() => widget.posts[index]['isLiked'] = !widget.posts[index]['isLiked']);
                },
                icon: const Icon(Icons.favorite_outlined),
                padding: EdgeInsets.zero);
      },
    );
  }

  Widget _userInfoRow(post) {
    return Row(
      children: [
        _avatar(post['user']['avatar']),
        Text(post['user']['username']),
        const Spacer(),
        if (post['isMine']) IconButton(onPressed: () {}, icon: const Icon(Icons.more))
      ],
    );
  }

  Widget _avatar(String avatarUrl) {
    return CircleAvatar(foregroundImage: NetworkImage(avatarUrl), radius: 20);
  }

  Widget _postImage(String imageUrl) {
    return AspectRatio(
      aspectRatio: 1,
      child: Image.network(
        imageUrl,
        fit: BoxFit.fill,
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text('Home View'),
      centerTitle: true,
    );
  }
}
