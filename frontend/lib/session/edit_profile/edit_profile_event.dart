part of 'edit_profile_bloc.dart';

abstract class EditProfileEvent extends Equatable {
  const EditProfileEvent();

  @override
  List<Object> get props => [];
}

class UsernameChanged extends EditProfileEvent {
  const UsernameChanged({required this.username});

  final String username;

  @override
  List<String> get props => [username];
}

class EmailChanged extends EditProfileEvent {
  const EmailChanged({required this.email});

  final String email;

  @override
  List<String> get props => [email];
}

class BioChanged extends EditProfileEvent {
  const BioChanged({required this.bio});

  final String bio;

  @override
  List<String> get props => [bio];
}

class PickImageRequest extends EditProfileEvent {
  const PickImageRequest();
}

class OpenImagePicker extends EditProfileEvent {
  const OpenImagePicker(this.imageSource);

  final ImageSource imageSource;

  @override
  List<ImageSource> get props => [imageSource];
}

class EditUserProvideImagePath extends EditProfileEvent {
  const EditUserProvideImagePath(this.imagePath);

  final String imagePath;

  @override
  List<String> get props => [imagePath];
}

class EditProfile extends EditProfileEvent {
  const EditProfile(this.data);

  final Map data;
}
