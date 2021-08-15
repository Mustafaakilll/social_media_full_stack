import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../add_post/add_post_view.dart';
import '../home/home_navigator/home_navigator.dart';
import '../profile/profile_view.dart';
import 'session_navigation_cubit.dart';

class SessionNavigator extends StatelessWidget {
  const SessionNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SessionNavigationCubit(),
      child: BlocBuilder<SessionNavigationCubit, SessionNavigationState>(
        builder: (context, state) {
          return Scaffold(
            body: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: Navigator(
                    pages: [
                      if (state is HomeSession) const MaterialPage(child: HomeNavigator()),
                      if (state is ProfileSession) MaterialPage(child: ProfileView()),
                      if (state is AddPostSession) const MaterialPage(child: AddPostView()),
                    ],
                    onPopPage: (route, result) => route.didPop(result),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: _bottomNavBar(context, state),
          );
        },
      ),
    );
  }

  Widget _bottomNavBar(BuildContext context, SessionNavigationState state) {
    return BottomNavigationBar(
      iconSize: 28,
      currentIndex: context.read<SessionNavigationCubit>().getIndex(state),
      onTap: (value) => context.read<SessionNavigationCubit>().updateIndex(value),
      items: [
        const BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Ana sayfa'),
        const BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Ekle'),
        const BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profil'),
      ],
    );
  }
}
