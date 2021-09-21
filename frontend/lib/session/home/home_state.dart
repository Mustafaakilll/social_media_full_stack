part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class PostLoading extends HomeState {
  const PostLoading();
}

class PostLoadedSuccess extends HomeState {
  const PostLoadedSuccess(this.posts);

  final List posts;

  @override
  List<Object> get props => [posts];
}

class NullPosts extends HomeState {
  const NullPosts();
}

class PostLoadedFail extends HomeState {
  const PostLoadedFail(this.exception);

  final Exception exception;

  @override
  List<Object> get props => [exception];
}

class PostLikeFailed extends HomeState {
  const PostLikeFailed(this.exception);

  final Exception exception;

  @override
  List<Object> get props => [exception];
}

class PostComment extends HomeState {
  const PostComment();
}
