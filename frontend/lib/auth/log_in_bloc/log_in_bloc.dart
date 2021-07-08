import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../auth_repository.dart';
import '../form_status.dart';

part 'log_in_event.dart';
part 'log_in_state.dart';

class LogInBloc extends Bloc<LogInEvent, LogInState> {
  LogInBloc(this.authRepo) : super(const LogInState());

  final AuthRepository authRepo;

  @override
  Stream<LogInState> mapEventToState(LogInEvent event) async* {
    if (event is EmailChanged) {
      yield state.copyWith(email: event.email);
    } else if (event is PasswordChanged) {
      yield state.copyWith(password: event.password);
    } else if (event is LogInSubmitted) {
      try {
        await authRepo.logIn(state.email, state.password);
        yield state.copyWith(formStatus: const SubmissionSuccess());
      } on Exception catch (e) {
        yield state.copyWith(formStatus: SubmissionFailure(e));
      }
    }
  }
}
