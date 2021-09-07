part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

class SearchUsernameChanged extends SearchEvent {
  const SearchUsernameChanged(this.username);

  final String username;

  @override
  List<Object> get props => [username];
}
