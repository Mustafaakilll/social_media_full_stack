part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class FetchUser extends ProfileEvent {
  FetchUser(this.username);

  final String username;

  @override
  List<Object> get props => [username];
}
