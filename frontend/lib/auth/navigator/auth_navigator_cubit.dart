import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_navigator_state.dart';

class AuthNavigatorCubit extends Cubit<AuthNavigatorState> {
  AuthNavigatorCubit() : super(LogIn());

  void showLogin() {
    emit(LogIn());
  }

  void showSignUp() {
    emit(SignUp());
  }

  //TODO: GO TO HOME PAGE
}
