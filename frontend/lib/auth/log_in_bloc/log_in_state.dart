part of 'log_in_bloc.dart';

//TODO: ADD VALIDATOR
class LogInState {
  LogInState({this.email = '', this.password = '', this.formStatus = const InitialFormStatus()});

  final String email;
  final String password;
  final FormSubmissionState formStatus;

  LogInState copyWith({
    String? email,
    String? password,
    FormSubmissionState? formStatus,
  }) {
    return LogInState(
      email: email ?? this.email,
      password: password ?? this.password,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
