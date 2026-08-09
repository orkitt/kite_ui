// Kite UI Components
// Copyright (c) 2026 Kite UI Contributors.
// Licensed under the MIT License. Keep this notice in substantial copies.
// Learn more: https://kite.orkitt.dev
import 'package:flutter/material.dart';

import '../design/design.dart';
import 'internal/kite_interactive.dart';

enum KiteAlertVariant { neutral, info, success, warning, error }

class KiteAlert extends StatelessWidget {
  const KiteAlert({
    required this.title,
    super.key,
    this.message,
    this.icon,
    this.variant = KiteAlertVariant.neutral,
    this.action,
    this.onClose,
  });

  final String title;
  final String? message;
  final IconData? icon;
  final KiteAlertVariant variant;
  final Widget? action;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;
    final type = context.typography;
    final accent = switch (variant) {
      KiteAlertVariant.info => colors.info,
      KiteAlertVariant.success => colors.success,
      KiteAlertVariant.warning => colors.warning,
      KiteAlertVariant.error => colors.error,
      KiteAlertVariant.neutral => colors.textSecondary,
    };
    final fill = switch (variant) {
      KiteAlertVariant.info => colors.infoSoft,
      KiteAlertVariant.success => colors.successSoft,
      KiteAlertVariant.warning => colors.warningSoft,
      KiteAlertVariant.error => colors.errorSoft,
      KiteAlertVariant.neutral => colors.muted,
    };

    return DecoratedBox(
      decoration: ShapeDecoration(
        color: fill,
        shape: Shapes.rounded12.copyWith(
          side: BorderSide(color: Color.lerp(colors.borderSoft, accent, .28)!),
        ),
      ),
      child: Padding(
        padding: Dimensions.p16,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: Dimensions.s32,
              height: Dimensions.s32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.card.withValues(alpha: .66),
                borderRadius: Dimensions.rad8,
              ),
              child: Icon(
                icon ?? _defaultIcon,
                color: accent,
                size: Dimensions.iconSm,
              ),
            ),
            Dimensions.gapH12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: type.title),
                  if (message != null) ...[
                    Dimensions.gapV4,
                    Text(
                      message!,
                      style: type.bodySmall.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                  if (action != null) ...[Dimensions.gapV12, action!],
                ],
              ),
            ),
            if (onClose != null) ...[
              Dimensions.gapH8,
              KitePressable(
                onTap: onClose,
                semanticLabel: 'Close alert',
                builder: (context, state) => AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  width: Dimensions.s32,
                  height: Dimensions.s32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: state.hovered
                        ? colors.card.withValues(alpha: .7)
                        : Colors.transparent,
                    borderRadius: Dimensions.rad8,
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    size: Dimensions.iconSm,
                    color: colors.icon,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData get _defaultIcon => switch (variant) {
    KiteAlertVariant.info => Icons.info_outline_rounded,
    KiteAlertVariant.success => Icons.check_circle_outline_rounded,
    KiteAlertVariant.warning => Icons.warning_amber_rounded,
    KiteAlertVariant.error => Icons.error_outline_rounded,
    KiteAlertVariant.neutral => Icons.notifications_none_rounded,
  };
}
