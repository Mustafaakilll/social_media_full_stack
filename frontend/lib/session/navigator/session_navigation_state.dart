part of 'session_navigation_cubit.dart';

abstract class SessionNavigationState extends Equatable {
  const SessionNavigationState();
}

class HomeSession extends SessionNavigationState {
  const HomeSession();

  @override
  List<Object?> get props => [];
}

class ProfileSession extends SessionNavigationState {
  const ProfileSession();

  @override
  List<Object?> get props => [];
}

class AddPostSession extends SessionNavigationState {
  const AddPostSession();

  @override
  List<Object?> get props => [];
}

class SearchSession extends SessionNavigationState {
  const SearchSession();

  @override
  List<Object?> get props => [];
}
