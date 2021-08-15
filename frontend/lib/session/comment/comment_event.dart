part of 'comment_bloc.dart';

abstract class CommentEvent extends Equatable {
  const CommentEvent();
}

class GetPostId extends CommentEvent {
  const GetPostId(this.postId);

  final String postId;

  @override
  List<Object> get props => [postId];
}

class CommentChanged extends CommentEvent {
  const CommentChanged(this.comment);

  final String comment;

  @override
  List<Object> get props => [comment];
}

class AddComment extends CommentEvent {
  const AddComment();

  @override
  List<Object> get props => [];
}
