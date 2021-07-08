import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../app_navigation_cubit.dart';

part 'auth_navigator_state.dart';

class AuthNavigatorCubit extends Cubit<AuthNavigatorState> {
  AuthNavigatorCubit(this._appNavCubit) : super(LogIn());

  final AppNavigationCubit _appNavCubit;

  void showLogin() {
    emit(LogIn());
  }

  void showSignUp() {
    emit(SignUp());
  }

  void showSession() {
    _appNavCubit.showSession();
  }
}
