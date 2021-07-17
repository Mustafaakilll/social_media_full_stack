part of 'add_post_bloc.dart';

class AddPostState extends Equatable {
  const AddPostState({
    this.tags = const [],
    this.imageUrl = '',
    this.caption = '',
    this.formStatus = const InitialFormStatus(),
    this.isVisibleSheet = false,
  });

  final String imageUrl;
  final String caption;
  final List<String> tags;
  final FormSubmissionState formStatus;
  final bool isVisibleSheet;

  AddPostState copyWith({
    String? imageUrl,
    String? caption,
    List<String>? tags,
    FormSubmissionState? formStatus,
    bool? isVisibleSheet,
  }) {
    return AddPostState(
      imageUrl: imageUrl ?? this.imageUrl,
      caption: caption ?? this.caption,
      tags: tags ?? this.tags,
      formStatus: formStatus ?? this.formStatus,
      isVisibleSheet: isVisibleSheet ?? this.isVisibleSheet,
    );
  }

  @override
  List<Object> get props => [imageUrl, caption, tags, formStatus, isVisibleSheet];
}
