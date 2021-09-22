part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class UserFetchedSuccessful extends ProfileState {
  UserFetchedSuccessful(this.user);

  final user;

  @override
  List<Object> get props => [user];
}

class UserFetchedFailure extends ProfileState {
  UserFetchedFailure(this.exception);

  final Exception exception;

  @override
  List<Object> get props => [exception];
}
