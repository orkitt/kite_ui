// Kite UI Components
// Copyright (c) 2026 Kite UI Contributors.
// Licensed under the MIT License. Keep this notice in substantial copies.

import 'package:flutter/material.dart';

import '../design/design.dart';
import 'internal/kite_interactive.dart';

class KiteToggle extends StatelessWidget {
  const KiteToggle({
    required this.selected,
    required this.onChanged,
    super.key,
    this.label,
    this.icon,
    this.enabled = true,
  });

  final bool selected;
  final ValueChanged<bool> onChanged;
  final String? label;
  final IconData? icon;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;

    return KitePressable(
      onTap: enabled ? () => onChanged(!selected) : null,
      semanticLabel: label,
      builder: (context, state) {
        final foreground = !state.enabled
            ? colors.textDisabled
            : selected
            ? colors.primary
            : colors.textSecondary;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          constraints: const BoxConstraints(
            minHeight: Dimensions.buttonHeightSm,
          ),
          padding: Dimensions.px12,
          decoration: ShapeDecoration(
            color: selected
                ? colors.primarySoft
                : state.hovered
                ? colors.muted
                : Colors.transparent,
            shape: Shapes.rounded12.copyWith(
              side: BorderSide(
                color: state.focused
                    ? colors.primary
                    : selected
                    ? colors.primarySoft
                    : colors.borderSoft,
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: Dimensions.iconSm, color: foreground),
                if (label != null) Dimensions.gapH8,
              ],
              if (label != null)
                Text(
                  label!,
                  style: context.typography.labelSmall.copyWith(
                    color: foreground,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
