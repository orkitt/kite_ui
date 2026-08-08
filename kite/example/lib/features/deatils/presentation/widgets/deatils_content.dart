import 'package:flutter/material.dart';

class DeatilsContent extends StatelessWidget {
  const DeatilsContent({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(child: Text('Deatils', style: textTheme.headlineSmall));
  }
}
