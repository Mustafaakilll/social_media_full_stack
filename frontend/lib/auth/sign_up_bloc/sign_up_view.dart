import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'sign_up_bloc.dart';

//TODO: ADD VALIDATOR
class SignUpView extends StatelessWidget {
  SignUpView({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpBloc(),
      child: Scaffold(
        appBar: _appBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              _signUpForm(),
              _logInButton(),
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
    return Form(
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
    );
  }

  Widget _usernameField() {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return TextFormField(
          decoration: const InputDecoration(
            hintText: 'Username',
            icon: Icon(Icons.person),
          ),
          onChanged: (value) => context.read<SignUpBloc>().add(UsernameChanged(value)),
        );
      },
    );
  }

  Widget _emailField() {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return TextFormField(
          decoration: const InputDecoration(
            hintText: 'Email',
            icon: Icon(Icons.email),
          ),
          onChanged: (value) => context.read<SignUpBloc>().add(EmailChanged(value)),
        );
      },
    );
  }

  Widget _passwordField() {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return TextFormField(
          decoration: const InputDecoration(
            hintText: 'Password',
            icon: Icon(Icons.security),
          ),
          onChanged: (value) => context.read<SignUpBloc>().add(PasswordChanged(value)),
        );
      },
    );
  }

  Widget _submitButton() {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: () => context.read<SignUpBloc>().add(const SignUpSubmitted()),
          child: const Text('Submit'),
        );
      },
    );
  }

  Widget _logInButton() {
    return TextButton(onPressed: () {}, child: const Text('Press here for login'));
  }
}
