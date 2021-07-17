part of 'session_navigation_cubit.dart';

abstract class SessionNavigationState extends Equatable {
  const SessionNavigationState();
}

class HomeSession extends SessionNavigationState {
  @override
  List<Object?> get props => [];
}

class ProfileSession extends SessionNavigationState {
  @override
  List<Object?> get props => [];
}

class AddPostSession extends SessionNavigationState {
  @override
  List<Object?> get props => [];
}
