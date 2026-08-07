// Kite UI Components
// Copyright (c) 2026 Kite UI Contributors.
// Licensed under the MIT License. Keep this notice in substantial copies.

import 'package:flutter/material.dart';

import '../design/design.dart';
import 'internal/kite_interactive.dart';

class KiteSwitch extends StatelessWidget {
  const KiteSwitch({
    required this.value,
    required this.onChanged,
    super.key,
    this.label,
    this.description,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;

    return KitePressable(
      onTap: onChanged == null ? null : () => onChanged!(!value),
      semanticLabel: label,
      builder: (context, state) {
        final control = AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          width: Dimensions.s48,
          height: Dimensions.s24,
          padding: const EdgeInsets.all(Dimensions.s2),
          decoration: BoxDecoration(
            color: !state.enabled
                ? colors.muted
                : value
                ? colors.primary
                : state.hovered
                ? colors.borderStrong
                : colors.border,
            borderRadius: Dimensions.radFull,
            border: Border.all(
              color: state.focused ? colors.primary : Colors.transparent,
              width: state.focused ? 1.5 : 0,
            ),
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: Dimensions.s20,
              height: Dimensions.s20,
              decoration: BoxDecoration(
                color: state.enabled ? colors.card : colors.textDisabled,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: colors.textPrimary.withValues(alpha: .10),
                    blurRadius: Dimensions.s4,
                    offset: const Offset(0, Dimensions.s2),
                  ),
                ],
              ),
            ),
          ),
        );

        if (label == null) return control;

        return Padding(
          padding: Dimensions.py8,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label!,
                      style: context.typography.label.copyWith(
                        color: state.enabled
                            ? colors.textPrimary
                            : colors.textDisabled,
                      ),
                    ),
                    if (description != null) ...[
                      Dimensions.gapV4,
                      Text(
                        description!,
                        style: context.typography.bodySmall.copyWith(
                          color: state.enabled
                              ? colors.textSecondary
                              : colors.textDisabled,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Dimensions.gapH16,
              control,
            ],
          ),
        );
      },
    );
  }
}
