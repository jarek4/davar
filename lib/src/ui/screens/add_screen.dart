import 'package:flutter/material.dart';

class AddScreen extends StatelessWidget {
  const AddScreen({Key? key}) : super(key: key);
  static const routeName = '/add';

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Add Screen', style: TextStyle(fontSize: 26),));
  }
}
