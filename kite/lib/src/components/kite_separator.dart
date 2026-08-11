// Kite UI Components
// Copyright (c) 2026 Kite UI Contributors.
// Licensed under the MIT License. Keep this notice in substantial copies.
// Learn more: https://kite.orkitt.dev
import 'package:flutter/material.dart';

import '../design/kolors.dart';

class KiteSeparator extends StatelessWidget {
  const KiteSeparator({super.key, this.vertical = false, this.space = 1});

  final bool vertical;
  final double space;

  @override
  Widget build(BuildContext context) {
    final color = context.colors.borderSoft;
    return SizedBox(
      width: vertical ? space : double.infinity,
      height: vertical ? double.infinity : space,
      child: Center(
        child: SizedBox(
          width: vertical ? 1 : double.infinity,
          height: vertical ? double.infinity : 1,
          child: ColoredBox(color: color),
        ),
      ),
    );
  }
}
