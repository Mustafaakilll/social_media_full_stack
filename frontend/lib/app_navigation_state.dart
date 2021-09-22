part of 'app_navigation_cubit.dart';

abstract class AppNavigationState extends Equatable {
  const AppNavigationState();

  @override
  List<Object> get props => [];
}

class UnknownState extends AppNavigationState {
  const UnknownState();
}

class UnauthenticatedState extends AppNavigationState {
  const UnauthenticatedState();
}

class AuthenticatedState extends AppNavigationState {
  const AuthenticatedState(this.user);

  final user;

  @override
  List<Object> get props => [user];
}
