import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_navigation_state.dart';

class HomeNavigationCubit extends Cubit<HomeNavigationState> {
  HomeNavigationCubit() : super(const FeedState());

  void showFeed() {
    emit(const FeedState());
  }

  void showProfile() {
    emit(const ProfileState());
  }

  void showComments(String postId, List comments, user) {
    emit(PostCommentState(postId, comments, user));
  }
}
