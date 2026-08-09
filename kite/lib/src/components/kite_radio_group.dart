// Kite UI Components
// Copyright (c) 2026 Kite UI Contributors.
// Licensed under the MIT License. Keep this notice in substantial copies.
// Learn more: https://kite.orkitt.dev
import 'package:flutter/material.dart';

import '../design/design.dart';
import 'internal/kite_interactive.dart';

class KiteRadioOption<T> {
  const KiteRadioOption({
    required this.value,
    required this.label,
    this.description,
  });

  final T value;
  final String label;
  final String? description;
}

class KiteRadioGroup<T> extends StatelessWidget {
  const KiteRadioGroup({
    required this.options,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final List<KiteRadioOption<T>> options;
  final T? value;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < options.length; index++) ...[
          _RadioRow<T>(
            option: options[index],
            selected: options[index].value == value,
            onTap: () => onChanged(options[index].value),
          ),
          if (index != options.length - 1) Dimensions.gapV8,
        ],
      ],
    );
  }
}

class _RadioRow<T> extends StatelessWidget {
  const _RadioRow({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final KiteRadioOption<T> option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;

    return KitePressable(
      onTap: onTap,
      semanticLabel: option.label,
      builder: (context, state) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          padding: Dimensions.p12,
          decoration: ShapeDecoration(
            color: selected
                ? colors.primarySoft
                : state.hovered
                ? colors.muted
                : colors.card,
            shape: Shapes.rounded12.copyWith(
              side: BorderSide(
                color: state.focused || selected
                    ? colors.primary
                    : colors.borderSoft,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: Dimensions.s20,
                height: Dimensions.s20,
                padding: const EdgeInsets.all(Dimensions.s4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.card,
                  border: Border.all(
                    color: selected ? colors.primary : colors.borderStrong,
                    width: selected ? Dimensions.s2 : 1,
                  ),
                ),
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 120),
                  scale: selected ? 1 : 0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: colors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              Dimensions.gapH12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(option.label, style: context.typography.label),
                    if (option.description != null) ...[
                      Dimensions.gapV4,
                      Text(
                        option.description!,
                        style: context.typography.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
