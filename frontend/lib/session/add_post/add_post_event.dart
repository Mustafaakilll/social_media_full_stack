part of 'add_post_bloc.dart';

abstract class AddPostEvent extends Equatable {
  const AddPostEvent();
}

class PickImageRequest extends AddPostEvent {
  const PickImageRequest();

  @override
  List<Object?> get props => [];
}

class OpenImagePicker extends AddPostEvent {
  const OpenImagePicker(this.imageSource);

  final ImageSource imageSource;

  @override
  List<Object> get props => [imageSource];
}

class ProvideImagePath extends AddPostEvent {
  const ProvideImagePath(this.imagePath);

  final String imagePath;

  @override
  List<Object> get props => [imagePath];
}

class CaptionChanged extends AddPostEvent {
  const CaptionChanged(this.caption);

  final String caption;

  @override
  List<Object> get props => [caption];
}

class TagsChanged extends AddPostEvent {
  const TagsChanged(this.tags);

  final List<String> tags;

  @override
  List<Object> get props => [tags];
}

class CreatePost extends AddPostEvent {
  const CreatePost();

  @override
  List<Object> get props => [];
}
