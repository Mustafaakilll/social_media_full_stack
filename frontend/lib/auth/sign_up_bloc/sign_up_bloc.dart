import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../utils/form_status.dart';
import '../auth_repository.dart';
import '../navigator/auth_navigator_cubit.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc(this._authRepo, this._authNavCubit) : super(const SignUpState());

  final AuthRepository _authRepo;
  final AuthNavigatorCubit _authNavCubit;

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
    if (event is UsernameChanged) {
      yield state.copyWith(username: event.props.first);
    } else if (event is EmailChanged) {
      yield state.copyWith(email: event.props.first);
    } else if (event is PasswordChanged) {
      yield state.copyWith(password: event.props.first);
    } else if (event is SignUpSubmitted) {
      yield state.copyWith(formStatus: const FormSubmitting());
      try {
        await _authRepo.signUp(state.username, state.email, state.password);
        yield state.copyWith(formStatus: const SubmissionSuccess());
        _authNavCubit.showSession();
      } on Exception catch (e) {
        yield state.copyWith(formStatus: SubmissionFailure(e));
      }
    }
  }
}
