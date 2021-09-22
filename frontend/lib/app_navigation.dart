import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_navigation_cubit.dart';
import 'auth/auth_repository.dart';
import 'auth/navigator/auth_navigator.dart';
import 'loading_view.dart';
import 'session/navigator/session_navigation.dart';

class AppNavigation extends StatelessWidget {
  const AppNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppNavigationCubit(context.read<AuthRepository>()),
      child: BlocBuilder<AppNavigationCubit, AppNavigationState>(
        builder: (context, state) {
          return _appNavigator(state);
        },
      ),
    );
  }

  Navigator _appNavigator(AppNavigationState state) {
    return Navigator(
      pages: [
        if (state is AuthenticatedState) MaterialPage(child: SessionNavigator()),
        if (state is UnauthenticatedState) const MaterialPage(child: AuthNavigator()),
        if (state is UnknownState) const MaterialPage(child: LoadingView())
      ],
      onPopPage: (route, result) => route.didPop(result),
    );
  }
}
