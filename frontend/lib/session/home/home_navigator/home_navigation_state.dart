part of 'home_navigation_cubit.dart';

// enum HomeNavigationState { feed, profile, comment }

abstract class HomeNavigationState extends Equatable {
  const HomeNavigationState();

  @override
  List<Object> get props => [];
}

class FeedState extends HomeNavigationState {
  const FeedState();

  @override
  List<Object> get props => [];
}

class ProfileState extends HomeNavigationState {
  //TODO: GET USERNAME OR ID AND DISPLAY IT
  const ProfileState();

  @override
  List<Object> get props => [];
}

class PostCommentState extends HomeNavigationState {
  PostCommentState(this.postId, this.comments, this.user);

  final String postId;
  final List comments;
  final user;

  @override
  List<Object> get props => [postId, comments, user];
}
