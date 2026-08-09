// Kite UI Components
// Copyright (c) 2026 Kite UI Contributors.
// Licensed under the MIT License. Keep this notice in substantial copies.
// Learn more: https://kite.orkitt.dev
import 'package:flutter/material.dart';

import '../design/design.dart';
import 'internal/kite_interactive.dart';

enum KiteButtonVariant { filled, outline, ghost, soft, danger }

enum KiteButtonSize { small, medium, large }

class KiteButton extends StatelessWidget {
  const KiteButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.variant = KiteButtonVariant.filled,
    this.size = KiteButtonSize.medium,
    this.leading,
    this.trailing,
    this.loading = false,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final KiteButtonVariant variant;
  final KiteButtonSize size;
  final Widget? leading;
  final Widget? trailing;
  final bool loading;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;
    final height = switch (size) {
      KiteButtonSize.small => Dimensions.buttonHeightSm,
      KiteButtonSize.medium => Dimensions.buttonHeightMd,
      KiteButtonSize.large => Dimensions.buttonHeightLg,
    };

    final pressable = KitePressable(
      semanticLabel: label,
      onTap: loading ? null : onPressed,
      builder: (context, state) {
        final foreground = _foreground(colors, state.enabled);
        final background = _background(colors, state);
        final border = _border(colors, state);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOutCubic,
          constraints: BoxConstraints(minHeight: height),
          padding: Dimensions.px16,
          decoration: ShapeDecoration(
            color: background,
            shape: Shapes.rounded12.copyWith(side: BorderSide(color: border)),
            shadows: state.focused
                ? [
                    BoxShadow(
                      color: colors.primary.withValues(alpha: .12),
                      blurRadius: Dimensions.s8,
                      spreadRadius: Dimensions.s2,
                    ),
                  ]
                : const [],
          ),
          child: DefaultTextStyle(
            style: context.typography.label.copyWith(color: foreground),
            child: IconTheme(
              data: IconThemeData(color: foreground, size: Dimensions.iconSm),
              child: Row(
                mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (loading)
                    SizedBox.square(
                      dimension: Dimensions.iconSm,
                      child: CircularProgressIndicator(
                        strokeWidth: Dimensions.s2,
                        color: foreground,
                      ),
                    )
                  else
                    ?leading,
                  if (loading || leading != null) Dimensions.gapH8,
                  Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
                  if (trailing != null) ...[Dimensions.gapH8, trailing!],
                ],
              ),
            ),
          ),
        );
      },
    );

    return expand
        ? SizedBox(width: double.infinity, child: pressable)
        : pressable;
  }

  Color _foreground(KiteColors colors, bool enabled) {
    if (!enabled) return colors.textDisabled;
    return switch (variant) {
      KiteButtonVariant.filled => colors.onPrimary,
      KiteButtonVariant.outline => colors.textPrimary,
      KiteButtonVariant.ghost => colors.textPrimary,
      KiteButtonVariant.soft => colors.primary,
      KiteButtonVariant.danger => colors.onPrimary,
    };
  }

  Color _background(KiteColors colors, KiteInteractionState state) {
    if (!state.enabled) return colors.muted;

    final base = switch (variant) {
      KiteButtonVariant.filled => colors.primary,
      KiteButtonVariant.outline => colors.card,
      KiteButtonVariant.ghost => Colors.transparent,
      KiteButtonVariant.soft => colors.primarySoft,
      KiteButtonVariant.danger => colors.error,
    };

    if (state.pressed) {
      if (variant == KiteButtonVariant.ghost ||
          variant == KiteButtonVariant.outline) {
        return colors.muted;
      }
      final target = variant == KiteButtonVariant.danger
          ? colors.textPrimary
          : colors.onPrimary;
      return Color.lerp(base, target, .10)!;
    }

    if (state.hovered) {
      if (variant == KiteButtonVariant.ghost ||
          variant == KiteButtonVariant.outline) {
        return colors.soft(colors.textPrimary, amount: .05);
      }
      final target = variant == KiteButtonVariant.danger
          ? colors.onPrimary
          : colors.onPrimary;
      return Color.lerp(base, target, .06)!;
    }

    return base;
  }

  Color _border(KiteColors colors, KiteInteractionState state) {
    if (!state.enabled) return colors.borderSoft;
    if (state.focused) {
      return variant == KiteButtonVariant.danger
          ? colors.error
          : colors.primary;
    }
    return switch (variant) {
      KiteButtonVariant.outline => colors.borderStrong,
      KiteButtonVariant.ghost => Colors.transparent,
      _ => Colors.transparent,
    };
  }
}
