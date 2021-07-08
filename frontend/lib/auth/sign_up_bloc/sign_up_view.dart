import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth_repository.dart';
import '../form_status.dart';
import '../navigator/auth_navigator_cubit.dart';
import 'sign_up_bloc.dart';

class SignUpView extends StatelessWidget {
  SignUpView({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpBloc(context.read<AuthRepository>(), context.read<AuthNavigatorCubit>()),
      child: Scaffold(
        appBar: _appBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              _signUpForm(),
              _logInButton(context),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text('Sign Up'),
      centerTitle: true,
    );
  }

  Widget _signUpForm() {
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        final formStatus = state.formStatus;
        if (formStatus is SubmissionFailure) {
          _showSnackBar(context, formStatus.exception.toString());
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _usernameField(),
            _emailField(),
            _passwordField(),
            _submitButton(),
          ],
        ),
      ),
    );
  }

  Widget _usernameField() {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return TextFormField(
          decoration: const InputDecoration(hintText: 'Username', icon: Icon(Icons.person)),
          validator: (value) => state.isValidUsername ? null : 'Your username has to be longer than 6 characters',
          onChanged: (value) => context.read<SignUpBloc>().add(UsernameChanged(value)),
        );
      },
    );
  }

  Widget _emailField() {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return TextFormField(
          decoration: const InputDecoration(hintText: 'Email', icon: Icon(Icons.email)),
          validator: (value) => state.isValidEmail ? null : 'Please enter valid email',
          onChanged: (value) => context.read<SignUpBloc>().add(EmailChanged(value)),
        );
      },
    );
  }

  Widget _passwordField() {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return TextFormField(
          decoration: const InputDecoration(hintText: 'Password', icon: Icon(Icons.security)),
          obscureText: true,
          validator: (value) => state.isValidPassword ? null : 'Your password has to be longer than 6 characters',
          onChanged: (value) => context.read<SignUpBloc>().add(PasswordChanged(value)),
        );
      },
    );
  }

  Widget _submitButton() {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return state.formStatus is FormSubmitting
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () => context.read<SignUpBloc>().add(const SignUpSubmitted()),
                child: const Text('Submit'),
              );
      },
    );
  }

  Widget _logInButton(BuildContext context) {
    return TextButton(
      onPressed: () => context.read<AuthNavigatorCubit>().showLogin(),
      child: const Text('Press here for login'),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final _snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(_snackBar);
  }
}
