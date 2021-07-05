part of 'sign_up_bloc.dart';

class SignUpState extends Equatable {
  const SignUpState({
    this.email = '',
    this.username = '',
    this.password = '',
    this.formStatus = const InitialFormStatus(),
  });

  final String email;
  final String username;
  final String password;
  final FormSubmissionState formStatus;

  bool get isValidUsername => username.length > 6;
  bool get isValidEmail => re.hasMatch(email);
  bool get isValidPassword => password.length > 8;

  SignUpState copyWith({
    String? email,
    String? username,
    String? password,
    FormSubmissionState? formStatus,
  }) {
    return SignUpState(
      email: email ?? this.email,
      username: username ?? this.username,
      password: password ?? this.password,
      formStatus: formStatus ?? this.formStatus,
    );
  }

  static final re = RegExp(r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)');

  @override
  List<Object?> get props => [email, username, password, formStatus];
}
