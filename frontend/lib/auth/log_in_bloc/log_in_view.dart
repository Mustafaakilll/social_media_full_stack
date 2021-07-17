import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth_repository.dart';
import '../form_status.dart';
import '../navigator/auth_navigator_cubit.dart';
import 'log_in_bloc.dart';

class LogInView extends StatelessWidget {
  LogInView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LogInBloc(context.read<AuthRepository>(), context.read<AuthNavigatorCubit>()),
      child: Scaffold(
        appBar: _appBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              _loginForm(),
              _signUpButton(context),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text('Log In'),
      centerTitle: true,
    );
  }

  Widget _loginForm() {
    return BlocListener<LogInBloc, LogInState>(
      listener: (context, state) {
        final formStatus = state.formStatus;
        if (formStatus is SubmissionFailure) {
          _showSnackBar(context, formStatus.exception.toString());
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _emailField(),
          _passwordField(),
          _submitButton(),
        ],
      ),
    );
  }

  Widget _emailField() {
    return BlocBuilder<LogInBloc, LogInState>(
      builder: (context, state) {
        return TextFormField(
          decoration: const InputDecoration(icon: Icon(Icons.email), hintText: 'Email'),
          validator: (value) => state.isValidEmail ? null : 'Please check your email',
          onChanged: (value) => context.read<LogInBloc>().add(EmailChanged(value)),
        );
      },
    );
  }

  Widget _passwordField() {
    return BlocBuilder<LogInBloc, LogInState>(
      builder: (context, state) {
        return TextFormField(
          obscureText: true,
          decoration: const InputDecoration(icon: Icon(Icons.security), hintText: 'Password'),
          onChanged: (v) => context.read<LogInBloc>().add(PasswordChanged(v)),
        );
      },
    );
  }

  Widget _submitButton() {
    return BlocBuilder<LogInBloc, LogInState>(
      builder: (context, state) {
        return state.formStatus is FormSubmitting
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () => context.read<LogInBloc>().add(LogInSubmitted()),
                child: const Text('Log In'),
              );
      },
    );
  }

  Widget _signUpButton(BuildContext context) {
    return TextButton(
        onPressed: () {
          context.read<AuthNavigatorCubit>().showSignUp();
        },
        child: const Text('Don"t you have account, press here to sign Up'));
  }

  void _showSnackBar(BuildContext context, String message) {
    final _snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(_snackBar);
  }
}
