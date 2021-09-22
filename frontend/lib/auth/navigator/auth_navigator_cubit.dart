import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../app_navigation_cubit.dart';

part 'auth_navigator_state.dart';

class AuthNavigatorCubit extends Cubit<AuthNavigatorState> {
  AuthNavigatorCubit(this._appNavCubit) : super(const LogIn());

  final AppNavigationCubit _appNavCubit;

  void showLogin() {
    emit(const LogIn());
  }

  void showSignUp() {
    emit(const SignUp());
  }

  void showSession() {
    _appNavCubit.showSession();
  }
}
