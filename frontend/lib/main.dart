import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_navigation.dart';
import 'auth/auth_repository.dart';
import 'session/post_repository.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthRepository()),
        RepositoryProvider(create: (context) => PostRepository()),
      ],
      child: const MaterialApp(
        title: 'Flutter Demo',
        home: AppNavigation(),
      ),
    );
  }
}
