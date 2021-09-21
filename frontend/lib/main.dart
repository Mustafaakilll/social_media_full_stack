import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_navigation.dart';
import 'auth/auth_repository.dart';
import 'session/comment/comment_repository.dart';
import 'session/post_repository.dart';
import 'session/user_repository.dart';
import 'utils/storage_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageHelper().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthRepository()),
        RepositoryProvider(create: (_) => UserRepository()),
        RepositoryProvider(create: (_) => PostRepository()),
        RepositoryProvider(create: (_) => CommentRepository()),
      ],
      child: const MaterialApp(
        title: 'Flutter Demo',
        home: AppNavigation(),
      ),
    );
  }
}
