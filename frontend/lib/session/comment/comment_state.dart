part of 'comment_bloc.dart';

class CommentState extends Equatable {
  CommentState({
    this.comments = const [],
    this.comment = '',
    this.postId = '',
    this.formStatus = const InitialFormStatus(),
  });

  final List<String> comments;
  final String comment;
  final String postId;
  final FormSubmissionState formStatus;

  @override
  List<Object> get props => [comments, comment, postId, formStatus];

  CommentState copyWith({
    List<String>? comments,
    String? comment,
    String? postId,
    FormSubmissionState? formStatus,
  }) {
    return CommentState(
      comments: comments ?? this.comments,
      comment: comment ?? this.comment,
      postId: postId ?? this.postId,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
