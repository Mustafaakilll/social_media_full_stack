import 'package:flutter/material.dart';

import 'auth/sign_up_bloc/sign_up_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: SignUpView(),
    );
  }
}
