part of 'log_in_bloc.dart';

abstract class LogInEvent extends Equatable {
  const LogInEvent();
}

class EmailChanged extends LogInEvent {
  EmailChanged(this.email);

  final String email;

  @override
  List<String?> get props => [email];
}

class PasswordChanged extends LogInEvent {
  PasswordChanged(this.password);

  final String password;

  @override
  List<String?> get props => [password];
}

class LogInSubmitted extends LogInEvent {
  @override
  List<Object?> get props => [];
}
