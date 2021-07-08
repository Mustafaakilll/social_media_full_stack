import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app_navigation_cubit.dart';
import '../log_in_bloc/log_in_view.dart';
import '../sign_up_bloc/sign_up_view.dart';
import 'auth_navigator_cubit.dart';

class AuthNavigator extends StatelessWidget {
  const AuthNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthNavigatorCubit(context.read<AppNavigationCubit>()),
      child: BlocBuilder<AuthNavigatorCubit, AuthNavigatorState>(
        builder: (context, state) {
          return Navigator(
            pages: [
              if (state is LogIn) MaterialPage(child: LogInView()),
              if (state is SignUp) MaterialPage(child: SignUpView())
            ],
            onPopPage: (route, result) => route.didPop(result),
          );
        },
      ),
    );
  }
}
