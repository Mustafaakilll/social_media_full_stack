import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth/auth_repository.dart';
import 'auth/navigator/auth_navigator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: const MaterialApp(
        title: 'Flutter Demo',
        home: AuthNavigator(),
      ),
    );
  }
}
