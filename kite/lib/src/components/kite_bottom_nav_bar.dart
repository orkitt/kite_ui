// Kite UI Components
// Copyright (c) 2026 Kite UI Contributors.
// Licensed under the MIT License. Keep this notice in substantial copies.

import 'package:flutter/material.dart';

import '../design/design.dart';
import 'internal/kite_interactive.dart';

class KiteBottomNavItem {
  const KiteBottomNavItem({
    required this.label,
    required this.icon,
    this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData? selectedIcon;
}

class KiteBottomNavBar extends StatelessWidget {
  const KiteBottomNavBar({
    required this.items,
    required this.selectedIndex,
    required this.onChanged,
    super.key,
  });

  final List<KiteBottomNavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.card,
        border: Border(top: BorderSide(color: colors.borderSoft)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: Dimensions.px8 + Dimensions.py8,
          child: Row(
            children: List.generate(items.length, (index) {
              return Expanded(
                child: _NavItem(
                  item: items[index],
                  selected: index == selectedIndex,
                  onTap: () => onChanged(index),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final KiteBottomNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;

    return KitePressable(
      onTap: onTap,
      semanticLabel: item.label,
      builder: (context, state) {
        final foreground = selected ? colors.primary : colors.textSecondary;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: 4.px,
          padding: Dimensions.py8,
          decoration: BoxDecoration(
            color: selected
                ? colors.primarySoft
                : state.hovered
                ? colors.muted
                : Colors.transparent,
            borderRadius: Dimensions.rad12,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                selected ? item.selectedIcon ?? item.icon : item.icon,
                size: Dimensions.iconMd,
                color: foreground,
              ),
              Dimensions.gapV4,
              Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.typography.caption.copyWith(
                  color: foreground,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
