import 'package:flutter/material.dart';

import '../widgets/blog_content.dart';

class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SafeArea(child: BlogContent()));
  }
}
