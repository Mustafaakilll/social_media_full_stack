part of 'app_navigation_cubit.dart';

abstract class AppNavigationState extends Equatable {
  const AppNavigationState();
}

class UnknownState extends AppNavigationState {
  @override
  List<Object?> get props => [];
}

class UnauthenticatedState extends AppNavigationState {
  @override
  List<Object?> get props => [];
}

class AuthenticatedState extends AppNavigationState {
  AuthenticatedState(this.user);

  final user;

  @override
  List<Object?> get props => [];
}
