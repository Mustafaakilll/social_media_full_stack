part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class GetPosts extends HomeEvent {
  @override
  List<Object?> get props => [];
}

//TODO: ADD LIKE AND UNLIKE EVENTS
