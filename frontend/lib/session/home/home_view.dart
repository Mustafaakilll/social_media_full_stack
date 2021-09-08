import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../loading_view.dart';
import '../../utils/context_extension.dart';
import '../../utils/storage_helper.dart';
import '../comment/comment_view.dart';
import '../post_repository.dart';
import '../profile/profile_view.dart';
import 'home_bloc.dart';

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
            return _ErrorBody(state.exception);
          } else if (state is PostLoadedSuccess) {
            return _SuccessBody();
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Something went wrong.Why don\'t you try again'),
            Text('$_exception'),
          ],
        ),
      ),
    );
  }
}

class _SuccessBody extends StatefulWidget {
  _SuccessBody({Key? key}) : super(key: key);

  @override
  __SuccessBodyState createState() => __SuccessBodyState();
}

class __SuccessBodyState extends State<_SuccessBody> {
  final _refreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _refreshFeed(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: _igLogo(),
      backgroundColor: const Color(0xffFFFFFF),
      elevation: 0,
    );
  }

  Widget _igLogo() {
    return SvgPicture.asset(
      'assets/iglogo.svg',
      height: 40,
      semanticsLabel: 'iglogo',
    );
  }

  Widget _refreshFeed() {
    return SmartRefresher(
      header: const ClassicHeader(),
      controller: _refreshController,
      enablePullDown: true,
      enablePullUp: false,
      onRefresh: () {
        context.read<HomeBloc>().add(const GetPosts());
        _refreshController.refreshCompleted();
      },
      enableTwoLevel: true,
      child: _postList(),
    );
  }

  Widget _postList() {
    return ListView.builder(
      itemCount: (context.read<HomeBloc>().state as PostLoadedSuccess).posts.length,
      itemBuilder: (BuildContext context, int index) {
        return _postCard(index);
      },
    );
  }

  Widget _postCard(int index) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        state = state as PostLoadedSuccess;
        return Card(
          child: Column(
            children: [
              _userInfoRow(state.posts[index]),
              _postImage(state.posts[index]['files'].first),
              _postActions(index, state.posts[index]['_id'], state.posts[index]['comments']),
              _likeCount(state.posts[index]['likesCount']),
              _postCaption(state.posts[index]),
            ],
          ),
        );
      },
    );
  }

  Widget _userInfoRow(Map post) {
    return SizedBox(
      height: context.deviceHeight * .07,
      child: Padding(
        padding: EdgeInsets.only(left: context.deviceWidth * .02),
        child: GestureDetector(
          onTap: () => context.navigateToPage(ProfileView(username: post['user']['username'])),
          child: Row(
            children: [
              _avatar(post['user']['avatar']),
              SizedBox(width: context.deviceWidth * .024),
              Text(post['user']['username']),
            ],
          ),
        ),
      ),
    );
  }

  Widget _avatar(String avatarUrl) {
    return CircleAvatar(
      foregroundImage: NetworkImage(avatarUrl),
      radius: context.deviceHeight * .03,
    );
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

  Widget _postActions(int index, String postId, List comments) {
    return Row(
      children: [
        _likeButton(index),
        _commentButton(postId, comments),
      ],
    );
  }

  Widget _likeButton(int index) {
    final state = context.read<HomeBloc>().state as PostLoadedSuccess;
    final postId = state.posts[index]['_id'];
    return Container(
      padding: EdgeInsets.only(left: 4, right: context.deviceWidth * .04),
      height: context.deviceHeight * .05,
      child: GestureDetector(
        onTap: () {
          context.read<HomeBloc>().add(ToggleLike(postId));
          if (!state.posts[index]['isLiked']) {
            state.posts[index]['likesCount']++;
            state.posts[index]['isLiked'] = !state.posts[index]['isLiked'];
          } else {
            state.posts[index]['likesCount']--;
            state.posts[index]['isLiked'] = !state.posts[index]['isLiked'];
          }

          setState(() {});
        },
        child: state.posts[index]['isLiked']
            ? const Icon(Icons.favorite_outlined, size: 28, color: Colors.red)
            : const Icon(Icons.favorite_outline, size: 28),
      ),
    );
  }

  Widget _commentButton(String postId, List comments) {
    return GestureDetector(
        onTap: () => StorageHelper().getData('user', 'auth').then(
            (value) => context.navigateToPage(CommentView(comments: comments, postId: postId, user: value as Map))),
        child: const FaIcon(FontAwesomeIcons.comment));
  }

  Widget _likeCount(int likeCount) {
    return Padding(
      padding: EdgeInsets.only(
        right: context.deviceWidth * .82,
        top: context.deviceHeight * .002,
        bottom: context.deviceHeight * .001,
      ),
      child: Text(
        '$likeCount likes',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _postCaption(Map post) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Row(
        children: [
          Text(post['user']['username'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(width: context.deviceWidth * .02),
          Expanded(
            child: Text(
              post['caption'],
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
