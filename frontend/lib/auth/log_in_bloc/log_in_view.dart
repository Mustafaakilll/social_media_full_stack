import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'log_in_bloc.dart';

class LogInView extends StatelessWidget {
  LogInView({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LogInBloc(),
      child: Scaffold(
        appBar: _appBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              _loginForm(),
              _signUpButton(),
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
    return Form(
      key: _formKey,
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
          decoration: const InputDecoration(
            icon: Icon(Icons.email),
            hintText: 'Email',
          ),
          onChanged: (value) => context.read<LogInBloc>().add(EmailChanged(value)),
        );
      },
    );
  }

  Widget _passwordField() {
    return BlocBuilder<LogInBloc, LogInState>(
      builder: (context, state) {
        return TextFormField(
          decoration: const InputDecoration(icon: Icon(Icons.security), hintText: 'Password'),
          onChanged: (v) => context.read<LogInBloc>().add(PasswordChanged(v)),
        );
      },
    );
  }

  Widget _submitButton() {
    return BlocBuilder<LogInBloc, LogInState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: () => context.read<LogInBloc>().add(LogInSubmitted()),
          child: const Text('Log In'),
        );
      },
    );
  }

  Widget _signUpButton() {
    return TextButton(onPressed: () {}, child: const Text('Don"t you have account, press here to sign Up'));
  }
}
