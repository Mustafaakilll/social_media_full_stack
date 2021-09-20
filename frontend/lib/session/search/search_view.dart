import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../loading_view.dart';
import '../../utils/context_extension.dart';
import '../profile/profile_view.dart';
import '../user_repository.dart';
import 'search_bloc.dart';

class SearchView extends StatelessWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchBloc(context.read<UserRepository>()),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              const _SearchBar(),
              const Expanded(child: _SearchBody()),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.deviceHeight * .07,
      child: TextField(
        onChanged: (value) {
          context.read<SearchBloc>().add(SearchUsernameChanged(value));
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(12),
          prefixIcon: const Icon(Icons.search),
          hintText: 'Search',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        autofocus: true,
      ),
    );
  }
}

class _SearchBody extends StatelessWidget {
  const _SearchBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchStateLoading) {
          return const LoadingView();
        }
        if (state is SearchStateError) {
          return Center(child: Text('Error ${state.exception.toString()}'));
        }
        if (state is SearchStateSuccess) {
          return _SearchResult(state.users);
        }
        if (state is SearchStateEmpty) {
          return Container();
        }
        return const Center(child: Text('Type to search users'));
      },
    );
  }
}

class _SearchResult extends StatelessWidget {
  const _SearchResult(this.users, {Key? key}) : super(key: key);

  final List users;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () => context.navigateToPage(ProfileView(username: users[index]['username'])),
          title: Text(users[index]['username']),
          leading: CircleAvatar(child: Image.network(users[index]['avatar'])),
        );
      },
    );
  }
}
