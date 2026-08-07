import 'package:flutter/material.dart';
import 'package:kite_todo_example/features/todo/presentation/screens/social.dart';

import 'showcase.dart';


class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return KiteComponentShowcaseScreen();
    //  return const Scaffold(body: SafeArea(child: TodoContent()));
  }
}
