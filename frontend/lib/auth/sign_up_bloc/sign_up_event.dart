part of 'sign_up_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();
}

class UsernameChanged extends SignUpEvent {
  const UsernameChanged(this.username);

  final String username;

  @override
  List<String?> get props => [username];
}

class EmailChanged extends SignUpEvent {
  const EmailChanged(this.email);

  final String email;

  @override
  List<String?> get props => [email];
}

class PasswordChanged extends SignUpEvent {
  const PasswordChanged(this.password);

  final String password;

  @override
  List<String?> get props => [password];
}

class SignUpSubmitted extends SignUpEvent {
  const SignUpSubmitted();

  @override
  List<Object?> get props => [];
}
