import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../auth_repository.dart';
import '../form_status.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc(this.authRepo) : super(const SignUpState());

  final AuthRepository authRepo;

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
    if (event is UsernameChanged) {
      yield state.copyWith(username: event.props.first);
    } else if (event is EmailChanged) {
      yield state.copyWith(email: event.props.first);
    } else if (event is PasswordChanged) {
      yield state.copyWith(password: event.props.first);
    } else if (event is SignUpSubmitted) {
      try {
        await authRepo.signUp(state.username, state.email, state.password);
        yield state.copyWith(formStatus: const SubmissionSuccess());
      } on Exception catch (e) {
        yield state.copyWith(formStatus: SubmissionFailure(e));
      }
    }
  }
}
