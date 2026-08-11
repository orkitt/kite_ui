// Kite UI Components
// Copyright (c) 2026 Kite UI Contributors.
// Licensed under the MIT License. Keep this notice in substantial copies.
// Learn more: https://kite.orkitt.dev
import 'package:flutter/material.dart';

import '../design/dimension.dart';
import '../design/kolors.dart';
import '../design/typography.dart';
import 'internal/kite_interactive.dart';

class KiteBreadcrumbItem {
  const KiteBreadcrumbItem({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;
}

class KiteBreadcrumb extends StatelessWidget {
  const KiteBreadcrumb({required this.items, super.key});

  final List<KiteBreadcrumbItem> items;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            KitePressable(
              onTap: items[i].onTap,
              semanticLabel: items[i].label,
              builder: (context, state) => AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                padding: Dimensions.p8,
                decoration: BoxDecoration(
                  color: state.hovered ? colors.muted : Colors.transparent,
                  borderRadius: Dimensions.rad8,
                ),
                child: Text(
                  items[i].label,
                  style: context.typography.labelSmall.copyWith(
                    color: i == items.length - 1
                        ? colors.textPrimary
                        : colors.textSecondary,
                  ),
                ),
              ),
            ),
            if (i != items.length - 1)
              Icon(
                Icons.chevron_right_rounded,
                size: Dimensions.iconSm,
                color: colors.textDisabled,
              ),
          ],
        ],
      ),
    );
  }
}
