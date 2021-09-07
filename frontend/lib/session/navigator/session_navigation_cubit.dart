import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'session_navigation_state.dart';

class SessionNavigationCubit extends Cubit<SessionNavigationState> {
  SessionNavigationCubit() : super(const HomeSession());

  int getIndex(SessionNavigationState state) {
    switch (state.runtimeType) {
      case HomeSession:
        return 0;
      case SearchSession:
        return 1;
      case AddPostSession:
        return 2;
      case ProfileSession:
        return 3;
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
        emit(const SearchSession());
        break;
      case 2:
        emit(const AddPostSession());
        break;
      case 3:
        emit(const ProfileSession());
        break;
      default:
        emit(const HomeSession());
    }
  }
}
