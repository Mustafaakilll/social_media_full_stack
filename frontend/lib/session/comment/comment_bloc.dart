import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../utils/form_status.dart';
import '../post_repository.dart';

part 'comment_event.dart';
part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  CommentBloc(this._postRepo) : super(CommentState());

  final PostRepository _postRepo;

  @override
  Stream<CommentState> mapEventToState(CommentEvent event) async* {
    if (event is CommentChanged) {
      yield state.copyWith(comment: event.comment);
    } else if (event is GetPostId) {
      yield state.copyWith(postId: event.postId);
    } else if (event is AddComment) {
      yield state.copyWith(formStatus: const FormSubmitting());
      try {
        await _postRepo.addComment(state.postId, state.comment);
        yield state.copyWith(comments: [...state.comments, state.comment]);
        yield state.copyWith(formStatus: const SubmissionSuccess());
      } on Exception catch (e) {
        yield state.copyWith(formStatus: SubmissionFailure(e));
      }
    }
  }
}
