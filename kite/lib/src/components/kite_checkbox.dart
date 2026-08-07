// Kite UI Components
// Copyright (c) 2026 Kite UI Contributors.
// Licensed under the MIT License. Keep this notice in substantial copies.

import 'package:flutter/material.dart';

import '../design/design.dart';
import 'internal/kite_interactive.dart';

class KiteCheckbox extends StatelessWidget {
  const KiteCheckbox({
    required this.value,
    required this.onChanged,
    super.key,
    this.label,
    this.description,
  });

  final bool value;
  final ValueChanged<bool?>? onChanged;
  final String? label;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;

    return KitePressable(
      onTap: onChanged == null ? null : () => onChanged!(!value),
      semanticLabel: label,
      builder: (context, state) {
        return Padding(
          padding: Dimensions.py4,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 140),
                width: Dimensions.s20,
                height: Dimensions.s20,
                alignment: Alignment.center,
                decoration: ShapeDecoration(
                  color: !state.enabled
                      ? colors.muted
                      : value
                      ? colors.primary
                      : state.hovered
                      ? colors.muted
                      : colors.card,
                  shape: RoundedRectangleBorder(
                    borderRadius: Dimensions.rad4,
                    side: BorderSide(
                      color: state.focused
                          ? colors.primary
                          : value
                          ? colors.primary
                          : colors.borderStrong,
                      width: state.focused ? 1.5 : 1,
                    ),
                  ),
                ),
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 120),
                  scale: value ? 1 : .6,
                  child: value
                      ? Icon(
                          Icons.check_rounded,
                          size: Dimensions.iconSm,
                          color: colors.onPrimary,
                        )
                      : const SizedBox.shrink(),
                ),
              ),
              if (label != null) ...[
                Dimensions.gapH12,
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
              ],
            ],
          ),
        );
      },
    );
  }
}
