// Kite UI Components
// Copyright (c) 2026 Kite UI Contributors.
// Licensed under the MIT License. Keep this notice in substantial copies.
// Learn more: https://kite.orkitt.dev
import 'package:flutter/material.dart';

import '../design/dimension.dart';
import 'kite_toggle.dart';

class KiteToggleGroup<T> extends StatelessWidget {
  const KiteToggleGroup({
    required this.items,
    required this.selected,
    required this.onChanged,
    super.key,
    this.multiSelect = false,
  });

  final List<KiteToggleGroupItem<T>> items;
  final Set<T> selected;
  final ValueChanged<Set<T>> onChanged;
  final bool multiSelect;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: Dimensions.s8,
      runSpacing: Dimensions.s8,
      children: items.map((item) {
        final active = selected.contains(item.value);
        return KiteToggle(
          selected: active,
          label: item.label,
          icon: item.icon,
          onChanged: (_) {
            final next = <T>{...selected};
            if (multiSelect) {
              active ? next.remove(item.value) : next.add(item.value);
            } else {
              next
                ..clear()
                ..add(item.value);
            }
            onChanged(next);
          },
        );
      }).toList(),
    );
  }
}

class KiteToggleGroupItem<T> {
  const KiteToggleGroupItem({
    required this.value,
    required this.label,
    this.icon,
  });
  final T value;
  final String label;
  final IconData? icon;
}
