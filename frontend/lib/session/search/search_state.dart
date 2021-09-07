part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchStateEmpty extends SearchState {
  const SearchStateEmpty();
}

class SearchStateLoading extends SearchState {
  const SearchStateLoading();
}

class SearchStateSuccess extends SearchState {
  const SearchStateSuccess(this.users);

  final List users;

  @override
  List<Object> get props => [users];
}

class SearchStateError extends SearchState {
  const SearchStateError(this.exception);

  final Exception exception;

  @override
  List<Object> get props => [exception];
}
