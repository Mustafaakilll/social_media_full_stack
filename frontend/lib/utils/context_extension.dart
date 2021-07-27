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
