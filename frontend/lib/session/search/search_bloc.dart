import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'search_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(this._searchRepo) : super(const SearchStateEmpty());

  final SearchRepository _searchRepo;

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is SearchUsernameChanged) {
      final username = event.username;
      if (username.isEmpty) {
        yield const SearchStateEmpty();
      } else {
        yield const SearchStateLoading();
        try {
          final results = await _searchRepo.searchUser(username);
          yield SearchStateSuccess(results);
        } on Exception catch (e) {
          yield SearchStateError(e);
        }
      }
    }
  }
}
