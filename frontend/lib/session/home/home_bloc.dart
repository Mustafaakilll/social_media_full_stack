import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../utils/image_url_cache.dart';
import '../post_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._postRepo) : super(const PostLoading()) {
    add(const GetPosts());
  }

  final PostRepository _postRepo;

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is GetPosts) {
      try {
        final postList = [...await _postRepo.getPosts()];

        for (var element in postList) {
          await ImageUrlCache().getUrl(element['_id']);
        }
        yield PostLoadedSuccess(postList);
      } on Exception catch (e) {
        yield PostLoadedFail(e);
      }
    } else if (event is ToggleLike) {
      try {
        await _postRepo.likePost(event.postId);
      } on Exception catch (e) {
        yield PostLikeFailed(e);
      }
    }
  }
}
