import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth/auth_repository.dart';
import '../session/post_repository.dart';
import '../session/user_repository.dart';

extension NavigationExtension on BuildContext {
  NavigatorState get _navigation => Navigator.of(this);

  void pop([dynamic data]) {
    _navigation.pop(data);
  }

  Future navigateToPage(Widget page) async {
    return await _navigation.push(MaterialPageRoute(builder: (context) => page));
  }
}

extension SizeExtension on BuildContext {
  Size get size => MediaQuery.of(this).size;

  double get deviceWidth => size.width;

  double get deviceHeight => size.height;
}

extension BlocExtension on BuildContext {
  List get repoProviders {
    return [
      RepositoryProvider(create: (_) => AuthRepository()),
      RepositoryProvider(create: (_) => UserRepository()),
      RepositoryProvider(create: (_) => PostRepository()),
    ];
  }
}
