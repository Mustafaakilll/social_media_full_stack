import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../user_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(this._userRepo) : super(ProfileState());

  final UserRepository _userRepo;

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is FetchUser) {
      try {
        final user = await _userRepo.getUserByUsername(event.username);
        yield UserFetchedSuccessful(user);
      } on Exception catch (e) {
        yield UserFetchedFailure(e);
      }
    }
  }
}
