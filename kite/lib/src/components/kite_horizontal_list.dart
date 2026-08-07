// Kite UI Components
// Copyright (c) 2026 Kite UI Contributors.
// Licensed under the MIT License. Keep this notice in substantial copies.

import 'package:flutter/material.dart';

import '../design/dimension.dart';

class KiteHorizontalListView extends StatelessWidget {
  const KiteHorizontalListView({
    required this.children,
    super.key,
    this.padding = Dimensions.px16,
    this.spacing = Dimensions.s12,
    this.controller,
    this.physics = const BouncingScrollPhysics(),
  });

  final List<Widget> children;
  final EdgeInsetsGeometry padding;
  final double spacing;
  final ScrollController? controller;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: controller,
      scrollDirection: Axis.horizontal,
      physics: physics,
      padding: padding,
      child: Row(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            children[i],
            if (i != children.length - 1) SizedBox(width: spacing),
          ],
        ],
      ),
    );
  }
}
