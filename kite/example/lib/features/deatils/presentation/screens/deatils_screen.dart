import 'package:flutter/material.dart';

import '../widgets/deatils_content.dart';

class DeatilsScreen extends StatelessWidget {
  const DeatilsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SafeArea(child: DeatilsContent()));
  }
}
