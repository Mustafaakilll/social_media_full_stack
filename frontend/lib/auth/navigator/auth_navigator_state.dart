part of 'auth_navigator_cubit.dart';

abstract class AuthNavigatorState extends Equatable {
  const AuthNavigatorState();

  @override
  List<Object> get props => [];
}

class LogIn extends AuthNavigatorState {
  const LogIn();
}

class SignUp extends AuthNavigatorState {
  const SignUp();
}
