import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../utils/storage_helper.dart';

part 'session_navigation_state.dart';

class SessionNavigationCubit extends Cubit<SessionNavigationState> {
  SessionNavigationCubit() : super(const HomeSession());

  int getIndex(SessionNavigationState state) {
    switch (state.runtimeType) {
      case HomeSession:
        return 0;
      case AddPostSession:
        return 1;
      case ProfileSession:
        return 2;
      default:
        return 0;
    }
  }

  void updateIndex(int index) async {
    switch (index) {
      case 0:
        emit(const HomeSession());
        break;
      case 1:
        emit(const AddPostSession());
        break;
      case 2:
        final _user = (await StorageHelper().getData('user', 'auth')) as Map;
        emit(ProfileSession(_user['username']));
        break;
      default:
        emit(const HomeSession());
    }
  }
}
