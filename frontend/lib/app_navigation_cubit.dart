import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'auth/auth_repository.dart';
import 'utils/storage_helper.dart';

part 'app_navigation_state.dart';

class AppNavigationCubit extends Cubit<AppNavigationState> {
  AppNavigationCubit(this._authRepo) : super(const UnknownState()) {
    attemptAutoLogin();
    // logOut();
  }

  final AuthRepository _authRepo;

  void attemptAutoLogin() async {
    try {
      final user = await _authRepo.attemptAutoLogin();
      user != null ? emit(AuthenticatedState(user)) : emit(const UnauthenticatedState());
    } on Exception {
      emit(const UnauthenticatedState());
    }
  }

  void showAuth() {
    emit(const UnauthenticatedState());
  }

  void showSession() async {
    try {
      var user = await StorageHelper().getData('user', 'auth');
      emit(AuthenticatedState(user));
    } catch (e) {
      emit(const UnauthenticatedState());
    }
  }

  void logOut() async {
    await _authRepo.logOut();
    emit(const UnauthenticatedState());
  }
}
