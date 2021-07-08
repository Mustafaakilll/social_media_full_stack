import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'auth/auth_repository.dart';
import 'utils/storage_helper.dart';

part 'app_navigation_state.dart';

class AppNavigationCubit extends Cubit<AppNavigationState> {
  AppNavigationCubit(this._authRepo) : super(UnknownState()) {
    attemptAutoLogin();
  }

  final AuthRepository _authRepo;

  void attemptAutoLogin() async {
    try {
      final user = await _authRepo.attemptAutoLogin();
      user != null ? emit(AuthenticatedState(user)) : emit(UnauthenticatedState());
    } on Exception {
      emit(UnauthenticatedState());
    }
  }

  void showAuth() {
    emit(UnauthenticatedState());
  }

  void showSession() async {
    try {
      var user = await StorageHelper().getData('user');
      emit(AuthenticatedState(user));
    } catch (e) {
      emit(UnauthenticatedState());
    }
  }

  void logOut() async {
    await _authRepo.logOut();
    emit(UnauthenticatedState());
  }
}
