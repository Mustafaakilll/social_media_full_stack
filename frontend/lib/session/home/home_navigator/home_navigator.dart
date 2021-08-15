import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../comment/comment_view.dart';
import '../../profile/profile_view.dart';
import '../home_view.dart';
import 'home_navigation_cubit.dart';

class HomeNavigator extends StatelessWidget {
  const HomeNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeNavigationCubit(),
      child: BlocBuilder<HomeNavigationCubit, HomeNavigationState>(
        builder: (context, state) {
          return Navigator(
            pages: [
              if (state is FeedState) const MaterialPage(child: HomeView()),
              if (state is ProfileState) MaterialPage(child: ProfileView()),
              if (state is PostCommentState)
                MaterialPage(child: CommentView(comments: state.comments, postId: state.postId, user: state.user)),
            ],
            onPopPage: (route, result) {
              context.read<HomeNavigationCubit>().showFeed();
              return route.didPop(result);
            },
          );
        },
      ),
    );
  }
}
