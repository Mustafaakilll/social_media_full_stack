import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_navigation.dart';
import 'utils/context_extension.dart';
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
      providers: [...context.repoProviders],
      child: const MaterialApp(
        title: 'Flutter Demo',
        home: AppNavigation(),
      ),
    );
  }
}
