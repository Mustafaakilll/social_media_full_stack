part of 'edit_profile_bloc.dart';

class EditProfileState extends Equatable {
  EditProfileState(
      {this.formStatus = const InitialFormStatus(),
      this.isVisibleSheet = false,
      this.username,
      this.bio,
      this.avatar,
      this.email});

  final String? username;
  final String? bio;
  final String? avatar;
  final String? email;
  final bool isVisibleSheet;
  final FormSubmissionState formStatus;

  @override
  List<Object?> get props => [
        username,
        bio,
        avatar,
        email,
        isVisibleSheet,
        formStatus,
      ];

  EditProfileState copyWith({
    String? username,
    String? bio,
    String? avatar,
    String? email,
    bool? isVisibleSheet,
    FormSubmissionState? formStatus,
  }) {
    return EditProfileState(
      username: username ?? this.username,
      bio: bio ?? this.bio,
      avatar: avatar ?? this.avatar,
      email: email ?? this.email,
      isVisibleSheet: isVisibleSheet ?? this.isVisibleSheet,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
