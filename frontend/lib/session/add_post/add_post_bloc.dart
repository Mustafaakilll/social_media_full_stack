import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import '../../auth/form_status.dart';
import '../post_repository.dart';

part 'add_post_event.dart';
part 'add_post_state.dart';

class AddPostBloc extends Bloc<AddPostEvent, AddPostState> {
  AddPostBloc(this._postRepo) : super(const AddPostState());

  final ImagePicker _picker = ImagePicker();
  final PostRepository _postRepo;

  @override
  Stream<AddPostState> mapEventToState(AddPostEvent event) async* {
    if (event is PickImageRequest) {
      yield state.copyWith(isVisibleSheet: true);
    } else if (event is OpenImagePicker) {
      yield state.copyWith(isVisibleSheet: false);
      final _pickedFile = await _picker.pickImage(source: event.imageSource);
      if (_pickedFile == null) return;
      final _imageUrl = await _postRepo.uploadFileToCloud(_pickedFile.path);
      yield state.copyWith(imageUrl: _imageUrl);
    } else if (event is CaptionChanged) {
      yield state.copyWith(caption: event.caption);
    } else if (event is TagsChanged) {
      yield state.copyWith(tags: event.tags);
    } else if (event is CreatePost) {
      yield state.copyWith(formStatus: const FormSubmitting());
      try {
        await _postRepo.addPost('state.caption', state.imageUrl, state.tags);
      } on Exception catch (e) {
        yield state.copyWith(formStatus: SubmissionFailure(e));
      }
    }
  }
}
