part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  ProfileState({this.userInfo = const {}});

  final Map userInfo;

  @override
  List<Object> get props => [userInfo];
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
