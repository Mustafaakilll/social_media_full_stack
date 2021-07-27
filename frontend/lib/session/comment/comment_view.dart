import 'package:flutter/material.dart';

class CommentView extends StatelessWidget {
  const CommentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: const Center(
        child: Text('Comment View'),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      leading: const BackButton(color: Colors.green),
      elevation: 0,
      backgroundColor: Colors.black,
      title: const Text('Comments', style: TextStyle(color: Colors.green)),
    );
  }
}
