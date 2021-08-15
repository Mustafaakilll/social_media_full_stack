import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

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

  void updateIndex(int index) {
    switch (index) {
      case 0:
        emit(const HomeSession());
        break;
      case 1:
        emit(const AddPostSession());
        break;
      case 2:
        emit(const ProfileSession());
        break;
      default:
        emit(const HomeSession());
    }
  }
}
