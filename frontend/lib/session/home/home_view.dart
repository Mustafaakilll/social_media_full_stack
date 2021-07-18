import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../loading_view.dart';
import '../post_repository.dart';
import 'home_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  //TODO: ADD FETCH IMAGEURL SINGLETON CLASS
  //TODO: ADD COMMENT FEATURE
  //TODO: COMPLETE ADD POST FEATURE FIRSTLY
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(context.read<PostRepository>()),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is PostLoadedFail) {
            return const Center(child: Text('Something went wrong'));
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

class _SuccessBody extends StatelessWidget {
  _SuccessBody({Key? key, required this.posts}) : super(key: key);

  final List posts;
  final _refreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: SmartRefresher(
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
          itemCount: posts.length,
          itemBuilder: (BuildContext context, int index) {
            return _postCard(index);
          },
        ),
      ),
    );
  }

  Card _postCard(int index) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _userInfoRow(posts[index]),
          _postImage(posts[index]['files'].first),
          posts[index]['isLiked']
              ? IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_outlined))
              : IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_outline))
        ],
      ),
    );
  }

  Row _userInfoRow(post) {
    return Row(
      children: [
        _avatar(post['user']['avatar']),
        Text(post['user']['username']),
        const Spacer(),
        if (post['isMine']) IconButton(onPressed: () {}, icon: const Icon(Icons.more))
      ],
    );
  }

  CircleAvatar _avatar(String avatarUrl) {
    return CircleAvatar(foregroundImage: NetworkImage(avatarUrl), radius: 20);
  }

  AspectRatio _postImage(String imageUrl) {
    return AspectRatio(
        aspectRatio: 1,
        child: Image.network(
          imageUrl,
          fit: BoxFit.fill,
        ));
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: const Text('Home View'),
      centerTitle: true,
    );
  }
}
