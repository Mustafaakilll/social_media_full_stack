import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/storage_helper.dart';
import '../add_post/add_post_view.dart';
import '../home/home_view.dart';
import '../profile/profile_view.dart';
import '../search/search_view.dart';
import 'session_navigation_cubit.dart';

class SessionNavigator extends StatelessWidget {
  SessionNavigator({Key? key}) : super(key: key) {
    StorageHelper().getData('user', 'auth').then((value) => username = (value as Map)['username']);
  }

  late final String username;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SessionNavigationCubit(),
      child: BlocBuilder<SessionNavigationCubit, SessionNavigationState>(
        builder: (context, state) {
          return Scaffold(
            body: _sessionBody(state),
            bottomNavigationBar: _bottomNavBar(context, state),
          );
        },
      ),
    );
  }

  Widget _sessionBody(SessionNavigationState state) {
    return Column(
      children: <Widget>[
        Expanded(child: _sessionNavigator(state)),
      ],
    );
  }

  Widget _sessionNavigator(SessionNavigationState state) {
    return Navigator(
      pages: [
        if (state is HomeSession) const MaterialPage(child: HomeView()),
        if (state is ProfileSession) MaterialPage(child: ProfileView(username: username)),
        if (state is AddPostSession) const MaterialPage(child: AddPostView()),
        if (state is SearchSession) const MaterialPage(child: SearchView()),
      ],
      onPopPage: (route, result) => route.didPop(result),
    );
  }

  Widget _bottomNavBar(BuildContext context, SessionNavigationState state) {
    return BottomNavigationBar(
      iconSize: 28,
      currentIndex: context.read<SessionNavigationCubit>().getIndex(state),
      onTap: (value) => context.read<SessionNavigationCubit>().updateIndex(value),
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      items: [
        const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home', activeIcon: Icon(Icons.home)),
        const BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        const BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline), label: 'Add', activeIcon: Icon(Icons.add_circle)),
        const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline), label: 'Profile', activeIcon: Icon(Icons.person)),
      ],
    );
  }
}
