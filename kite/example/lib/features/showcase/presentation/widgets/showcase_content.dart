import 'package:flutter/material.dart';

class ShowcaseContent extends StatelessWidget {
  const ShowcaseContent({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(child: Text('Showcase', style: textTheme.headlineSmall));
  }
}
