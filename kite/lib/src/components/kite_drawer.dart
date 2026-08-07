// Kite UI Components
// Copyright (c) 2026 Kite UI Contributors.
// Licensed under the MIT License. Keep this notice in substantial copies.

import 'package:flutter/material.dart';

import '../design/design.dart';

class KiteDrawer extends StatelessWidget {
  const KiteDrawer({
    required this.child,
    super.key,
    this.header,
    this.footer,
    this.width = Dimensions.s64 * 4 + Dimensions.s48,
  });

  final Widget child;
  final Widget? header;
  final Widget? footer;
  final double width;

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;

    return SizedBox(
      width: width,
      child: Material(
        color: colors.card,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(right: BorderSide(color: colors.borderSoft)),
          ),
          child: SafeArea(
            child: Column(
              children: [
                if (header != null) ...[
                  Padding(padding: Dimensions.p16, child: header!),
                  Container(height: 1, color: colors.borderSoft),
                ],
                Expanded(child: child),
                if (footer != null) ...[
                  Container(height: 1, color: colors.borderSoft),
                  Padding(padding: Dimensions.p16, child: footer!),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
