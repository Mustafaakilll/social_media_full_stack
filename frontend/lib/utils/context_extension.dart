import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

extension NavigationExtension on BuildContext {
  NavigatorState get navigation => Navigator.of(this);

  Future pop() async {
    await navigation.maybePop();
  }

  Future navigateToPage(Widget page) async {
    return await navigation.push(MaterialPageRoute(builder: (context) => page));
  }
}

extension SizeExtension on BuildContext {
  Size get size => MediaQuery.of(this).size;

  double get deviceWidth => size.width;
  double get deviceHeight => size.height;
}
