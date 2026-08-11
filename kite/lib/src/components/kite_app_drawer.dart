// Kite UI Components
// Copyright (c) 2026 Kite UI Contributors.
// Licensed under the MIT License. Keep this notice in substantial copies.
// Learn more: https://kite.orkitt.dev
import 'package:flutter/material.dart';

import '../design/dimension.dart';
import '../design/kolors.dart';
import '../design/typography.dart';
import 'internal/kite_interactive.dart';
import 'kite_badge.dart';
import 'kite_drawer.dart';

class KiteDrawerDestination {
  const KiteDrawerDestination({
    required this.label,
    required this.icon,
    this.badge,
  });

  final String label;
  final IconData icon;
  final String? badge;
}

class KiteAppDrawer extends StatelessWidget {
  const KiteAppDrawer({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    super.key,
    this.header,
    this.footer,
  });

  final List<KiteDrawerDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget? header;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return KiteDrawer(
      header: header,
      footer: footer,
      child: ListView.separated(
        padding: Dimensions.p12,
        itemCount: destinations.length,
        separatorBuilder: (_, _) => Dimensions.vBox4,
        itemBuilder: (context, index) {
          final item = destinations[index];
          return _DrawerDestinationRow(
            item: item,
            selected: index == selectedIndex,
            onTap: () => onDestinationSelected(index),
          );
        },
      ),
    );
  }
}

class _DrawerDestinationRow extends StatelessWidget {
  const _DrawerDestinationRow({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final KiteDrawerDestination item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return KitePressable(
      onTap: onTap,
      semanticLabel: item.label,
      builder: (context, state) {
        final foreground = selected ? colors.primary : colors.textPrimary;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 130),
          constraints: const BoxConstraints(minHeight: Dimensions.touchTarget),
          padding: Dimensions.px12,
          decoration: BoxDecoration(
            color: selected
                ? colors.primarySoft
                : state.hovered
                ? colors.muted
                : Colors.transparent,
            borderRadius: Dimensions.rad12,
            border: Border.all(
              color: state.focused ? colors.primary : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              Icon(
                item.icon,
                size: Dimensions.iconMd,
                color: selected ? colors.primary : colors.icon,
              ),
              Dimensions.hBox12,
              Expanded(
                child: Text(
                  item.label,
                  style: context.typography.label.copyWith(color: foreground),
                ),
              ),
              if (item.badge != null) ...[
                Dimensions.hBox8,
                KiteBadge(
                  item.badge!,
                  variant: selected
                      ? KiteBadgeVariant.primary
                      : KiteBadgeVariant.neutral,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
