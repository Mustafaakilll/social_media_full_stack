part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class GetPosts extends HomeEvent {
  @override
  List<Object?> get props => [];
}

class ToggleLike extends HomeEvent {
  ToggleLike(this.postId);

  final String postId;

  @override
  List<Object> get props => [postId];
}
