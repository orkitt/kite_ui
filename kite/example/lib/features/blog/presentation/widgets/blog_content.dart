import 'package:flutter/material.dart';

class BlogContent extends StatelessWidget {
  const BlogContent({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(child: Text('Blog', style: textTheme.headlineSmall));
  }
}
