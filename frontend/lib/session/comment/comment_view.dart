import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../home/home_navigator/home_navigation_cubit.dart';
import 'comment_bloc.dart';
import 'comment_repository.dart';

//TODO: TRY REMOVE BOTTOM NAV BAR
class CommentView extends StatelessWidget {
  CommentView({required this.comments, Key? key, required this.postId, required this.user}) : super(key: key);

  final List comments;
  final String postId;
  final user;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CommentBloc(context.read<CommentRepository>())..add(GetPostId(postId)),
      child: Scaffold(
        body: _buildPage(context),
        appBar: _appBar(context),
      ),
    );
  }

  Widget _buildPage(context) {
    return Column(
      children: [
        _commentView(),
        _rowCommentField(),
      ],
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      leading: BackButton(color: Colors.green, onPressed: () => context.read<HomeNavigationCubit>().showFeed()),
      elevation: 0,
      backgroundColor: Colors.black,
      title: const Text('Comments', style: TextStyle(color: Colors.green)),
    );
  }

  Widget _commentView() {
    return BlocBuilder<CommentBloc, CommentState>(
      builder: (context, state) {
        return Expanded(
          child: ListView.builder(
            itemCount: comments.length,
            itemBuilder: (BuildContext context, int index) {
              log(comments[index].toString());
              return ListTile(
                leading: CircleAvatar(foregroundImage: NetworkImage(comments[index]['user']['avatar']), radius: 20),
                subtitle: Text(comments[index]['text']),
                title: Text(comments[index]['user']['username']),
              );
            },
          ),
        );
      },
    );
  }

  Widget _rowCommentField() {
    return BlocBuilder<CommentBloc, CommentState>(
      builder: (context, state) {
        return Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: TextFormField(
                autofocus: true,
                onChanged: (value) => context.read<CommentBloc>().add(CommentChanged(value)),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  border: UnderlineInputBorder(borderSide: BorderSide(width: 2)),
                ),
              ),
            ),
            TextButton(
                onPressed: () {
                  comments.add({'user': user, 'text': state.comment});
                  context.read<CommentBloc>().add(const AddComment());
                },
                child: const Text('Post')),
          ],
        );
      },
    );
  }
}
