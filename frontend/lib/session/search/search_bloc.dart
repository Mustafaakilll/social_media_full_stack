import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../user_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(this._userRepo) : super(const SearchStateEmpty());

  final UserRepository _userRepo;

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is SearchUsernameChanged) {
      final username = event.username;
      if (username.isEmpty) {
        yield const SearchStateEmpty();
      } else {
        yield const SearchStateLoading();
        try {
          final results = await _userRepo.searchUser(username);
          yield results.isNotEmpty ? SearchStateSuccess(results) : const SearchStateEmpty();
        } on Exception catch (e) {
          yield SearchStateError(e);
        }
      }
    }
  }
}
