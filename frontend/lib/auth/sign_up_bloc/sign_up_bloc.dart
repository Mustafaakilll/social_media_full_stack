import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../form_status.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(const SignUpState());

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
    if (event is UsernameChanged) {
      yield state.copyWith(username: event.props.first);
    } else if (event is EmailChanged) {
      yield state.copyWith(email: event.props.first);
    } else if (event is PasswordChanged) {
      yield state.copyWith(password: event.props.first);
    } else if (event is SignUpSubmitted) {
      yield state.copyWith(formStatus: const SubmissionSuccess());
    }
  }
}
