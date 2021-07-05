part of 'log_in_bloc.dart';

class LogInState {
  const LogInState({this.email = '', this.password = '', this.formStatus = const InitialFormStatus()});

  final String email;
  final String password;
  final FormSubmissionState formStatus;

  bool get isValidEmail => _re.hasMatch(email);
  bool get isValidPassword => password.length > 6;

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

  static final _re = RegExp(r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)');
}
