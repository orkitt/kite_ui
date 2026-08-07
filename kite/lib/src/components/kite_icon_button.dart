// Kite UI Components
// Copyright (c) 2026 Kite UI Contributors.
// Licensed under the MIT License. Keep this notice in substantial copies.

import 'package:flutter/material.dart';

import '../design/design.dart';
import 'internal/kite_interactive.dart';

enum KiteIconButtonVariant { ghost, soft, outline, filled, danger }

class KiteIconButton extends StatelessWidget {
  const KiteIconButton({
    required this.icon,
    required this.onPressed,
    super.key,
    this.tooltip,
    this.variant = KiteIconButtonVariant.ghost,
    this.size = Dimensions.touchTarget,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final KiteIconButtonVariant variant;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;

    final button = KitePressable(
      semanticLabel: tooltip,
      onTap: onPressed,
      builder: (context, state) {
        final foreground = _foreground(colors, state.enabled);
        final background = _background(colors, state);
        final border = state.focused
            ? (variant == KiteIconButtonVariant.danger
                  ? colors.error
                  : colors.primary)
            : variant == KiteIconButtonVariant.outline
            ? colors.border
            : Colors.transparent;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: ShapeDecoration(
            color: background,
            shape: Shapes.rounded12.copyWith(side: BorderSide(color: border)),
          ),
          child: Icon(icon, size: Dimensions.iconMd, color: foreground),
        );
      },
    );

    return tooltip == null ? button : Tooltip(message: tooltip!, child: button);
  }

  Color _foreground(KiteColors colors, bool enabled) {
    if (!enabled) return colors.textDisabled;
    return switch (variant) {
      KiteIconButtonVariant.filled => colors.onPrimary,
      KiteIconButtonVariant.soft => colors.primary,
      KiteIconButtonVariant.danger => colors.error,
      _ => colors.icon,
    };
  }

  Color _background(KiteColors colors, KiteInteractionState state) {
    if (!state.enabled) return colors.muted;

    final base = switch (variant) {
      KiteIconButtonVariant.filled => colors.primary,
      KiteIconButtonVariant.soft => colors.primarySoft,
      KiteIconButtonVariant.outline => colors.card,
      KiteIconButtonVariant.ghost => Colors.transparent,
      KiteIconButtonVariant.danger => colors.errorSoft,
    };

    if (state.pressed) {
      return variant == KiteIconButtonVariant.ghost ||
              variant == KiteIconButtonVariant.outline
          ? colors.muted
          : Color.lerp(base, colors.textPrimary, .08)!;
    }
    if (state.hovered) {
      return variant == KiteIconButtonVariant.ghost ||
              variant == KiteIconButtonVariant.outline
          ? colors.soft(colors.textPrimary, amount: .05)
          : Color.lerp(base, colors.textPrimary, .04)!;
    }
    return base;
  }
}
