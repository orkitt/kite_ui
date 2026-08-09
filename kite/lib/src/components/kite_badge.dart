// Kite UI Components
// Copyright (c) 2026 Kite UI Contributors.
// Licensed under the MIT License. Keep this notice in substantial copies.
// Learn more: https://kite.orkitt.dev
import 'package:flutter/material.dart';

import '../design/design.dart';

enum KiteBadgeVariant { neutral, primary, success, warning, error, info }

class KiteBadge extends StatelessWidget {
  const KiteBadge(
    this.label, {
    super.key,
    this.variant = KiteBadgeVariant.neutral,
    this.icon,
  });

  final String label;
  final KiteBadgeVariant variant;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;
    final foreground = switch (variant) {
      KiteBadgeVariant.primary => colors.primary,
      KiteBadgeVariant.success => colors.success,
      KiteBadgeVariant.warning => colors.warning,
      KiteBadgeVariant.error => colors.error,
      KiteBadgeVariant.info => colors.info,
      KiteBadgeVariant.neutral => colors.textSecondary,
    };
    final background = switch (variant) {
      KiteBadgeVariant.primary => colors.primarySoft,
      KiteBadgeVariant.success => colors.successSoft,
      KiteBadgeVariant.warning => colors.warningSoft,
      KiteBadgeVariant.error => colors.errorSoft,
      KiteBadgeVariant.info => colors.infoSoft,
      KiteBadgeVariant.neutral => colors.muted,
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: Dimensions.radFull,
      ),
      child: Padding(
        padding: Dimensions.px8 + Dimensions.py4,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: Dimensions.iconSm, color: foreground),
              Dimensions.gapH4,
            ],
            Text(
              label,
              style: context.typography.labelSmall.copyWith(color: foreground),
            ),
          ],
        ),
      ),
    );
  }
}
