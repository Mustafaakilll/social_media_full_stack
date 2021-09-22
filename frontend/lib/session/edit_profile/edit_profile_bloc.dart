import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/form_status.dart';
import '../post_repository.dart';
import '../user_repository.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc(this._postRepo, this._userRepo) : super(EditProfileState());

  final ImagePicker _picker = ImagePicker();
  final PostRepository _postRepo;
  final UserRepository _userRepo;

  @override
  Stream<EditProfileState> mapEventToState(EditProfileEvent event) async* {
    if (event is PickImageRequest) {
      yield state.copyWith(isVisibleSheet: true);
    } else if (event is OpenImagePicker) {
      yield state.copyWith(isVisibleSheet: false);
      final _pickedFile = await _picker.pickImage(source: event.imageSource);
      if (_pickedFile == null) return;
      final _imageUrl = await _postRepo.uploadFileToCloud(_pickedFile.path);
      yield state.copyWith(avatar: _imageUrl);
    } else if (event is EditUserProvideImagePath) {
      yield state.copyWith(avatar: event.imagePath);
    } else if (event is UsernameChanged) {
      yield state.copyWith(username: event.username);
    } else if (event is EmailChanged) {
      yield state.copyWith(email: event.email);
    } else if (event is BioChanged) {
      yield state.copyWith(bio: event.bio);
    } else if (event is EditProfile) {
      yield state.copyWith(formStatus: const FormSubmitting());
      try {
        final updatedUser = {
          'username': state.username ?? event.data['username'],
          'email': state.email ?? event.data['email'],
          'bio': state.bio ?? event.data['bio'],
          'avatar': state.avatar ?? event.data['avatar']
        };
        final newUser = await _userRepo.editUser(updatedUser);
        yield state.copyWith(avatar: newUser['avatar']);
        yield state.copyWith(formStatus: const SubmissionSuccess());
      } on Exception catch (e) {
        yield state.copyWith(formStatus: SubmissionFailure(e));
      }
    }
  }
}
