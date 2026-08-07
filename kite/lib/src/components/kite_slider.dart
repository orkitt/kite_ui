// Kite UI Components
// Copyright (c) 2026 Kite UI Contributors.
// Licensed under the MIT License. Keep this notice in substantial copies.

import 'package:flutter/material.dart';

import '../design/design.dart';

class KiteSlider extends StatelessWidget {
  const KiteSlider({
    required this.value,
    required this.onChanged,
    super.key,
    this.min = 0,
    this.max = 1,
    this.label,
    this.showValue = false,
  });

  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;
  final String? label;
  final bool showValue;

  @override
  Widget build(BuildContext context) {
    final normalized = max <= min
        ? 0.0
        : ((value - min) / (max - min)).clamp(0.0, 1.0).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null || showValue) ...[
          Row(
            children: [
              if (label != null)
                Expanded(
                  child: Text(label!, style: context.typography.labelSmall),
                ),
              if (showValue)
                Text(
                  value.toStringAsFixed(
                    value.truncateToDouble() == value ? 0 : 1,
                  ),
                  style: context.typography.caption,
                ),
            ],
          ),
          Dimensions.gapV8,
        ],
        Semantics(
          slider: true,
          enabled: onChanged != null,
          value: '$value',
          increasedValue: '${(value + (max - min) * .05).clamp(min, max)}',
          decreasedValue: '${(value - (max - min) * .05).clamp(min, max)}',
          onIncrease: onChanged == null
              ? null
              : () => onChanged!(
                  (value + (max - min) * .05).clamp(min, max).toDouble(),
                ),
          onDecrease: onChanged == null
              ? null
              : () => onChanged!(
                  (value - (max - min) * .05).clamp(min, max).toDouble(),
                ),
          child: SizedBox(
            height: Dimensions.s32,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapDown: onChanged == null
                      ? null
                      : (details) => _update(
                          details.localPosition.dx,
                          constraints.maxWidth,
                        ),
                  onHorizontalDragUpdate: onChanged == null
                      ? null
                      : (details) => _update(
                          details.localPosition.dx,
                          constraints.maxWidth,
                        ),
                  child: _SliderTrack(
                    normalized: normalized,
                    enabled: onChanged != null,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _update(double dx, double width) {
    if (width <= 0 || onChanged == null) return;
    final position = (dx / width).clamp(0.0, 1.0).toDouble();
    onChanged!(min + (max - min) * position);
  }
}

class _SliderTrack extends StatelessWidget {
  const _SliderTrack({required this.normalized, required this.enabled});

  final double normalized;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;

    return LayoutBuilder(
      builder: (context, constraints) {
        final usable = constraints.maxWidth - Dimensions.s20;
        final thumbLeft = usable * normalized;

        return Stack(
          alignment: Alignment.centerLeft,
          children: [
            Positioned(
              left: 0,
              right: 0,
              child: Container(
                height: Dimensions.s4,
                decoration: BoxDecoration(
                  color: colors.muted,
                  borderRadius: Dimensions.radFull,
                ),
              ),
            ),
            Positioned(
              left: 0,
              width: thumbLeft + (Dimensions.s20 / 2),
              child: Container(
                height: Dimensions.s4,
                decoration: BoxDecoration(
                  color: enabled ? colors.primary : colors.textDisabled,
                  borderRadius: Dimensions.radFull,
                ),
              ),
            ),
            Positioned(
              left: thumbLeft,
              child: Container(
                width: Dimensions.s20,
                height: Dimensions.s20,
                decoration: BoxDecoration(
                  color: colors.card,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: enabled ? colors.primary : colors.textDisabled,
                    width: Dimensions.s2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colors.textPrimary.withValues(alpha: .10),
                      blurRadius: Dimensions.s8,
                      offset: const Offset(0, Dimensions.s2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
