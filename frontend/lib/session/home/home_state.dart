part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class PostLoading extends HomeState {
  @override
  List<Object?> get props => [];
}

class PostLoadedSuccess extends HomeState {
  PostLoadedSuccess(this.posts);

  final List posts;

  @override
  List<Object?> get props => [posts];
}

class NullPosts extends HomeState {
  @override
  List<Object?> get props => [];
}

class PostLoadedFail extends HomeState {
  PostLoadedFail(this.exception);

  final Exception exception;

  @override
  List<Object?> get props => [exception];
}
