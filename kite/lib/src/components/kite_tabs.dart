// Kite UI Components
// Copyright (c) 2026 Kite UI Contributors.
// Licensed under the MIT License. Keep this notice in substantial copies.
// Learn more: https://kite.orkitt.dev
import 'package:flutter/material.dart';

import '../design/dimension.dart';
import '../design/kolors.dart';
import '../design/shapes.dart';
import '../design/typography.dart';
import 'internal/kite_interactive.dart';

class KiteTabItem {
  const KiteTabItem({required this.label, required this.child, this.icon});

  final String label;
  final Widget child;
  final IconData? icon;
}

class KiteTabs extends StatefulWidget {
  const KiteTabs({
    required this.items,
    super.key,
    this.isScrollable = false,
    this.initialIndex = 0,
    this.onChanged,
  }) : assert(items.length > 0);

  final List<KiteTabItem> items;
  final bool isScrollable;
  final int initialIndex;
  final ValueChanged<int>? onChanged;

  @override
  State<KiteTabs> createState() => _KiteTabsState();
}

class _KiteTabsState extends State<KiteTabs> {
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex.clamp(0, widget.items.length - 1).toInt();
  }

  void _select(int index) {
    if (_index == index) return;
    setState(() => _index = index);
    widget.onChanged?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final controls = Container(
      padding: Dimensions.p4,
      decoration: ShapeDecoration(
        color: colors.muted,
        shape: Shapes.rounded12.copyWith(
          side: BorderSide(color: colors.borderSoft),
        ),
      ),
      child: widget.isScrollable
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: _buildTabs()),
            )
          : Row(children: _buildTabs(expanded: true)),
    );

    return Column(
      children: [
        controls,
        Dimensions.vBox16,
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SizeTransition(
              sizeFactor: animation,
              axisAlignment: -1,
              child: child,
            ),
          ),
          child: KeyedSubtree(
            key: ValueKey(_index),
            child: widget.items[_index].child,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildTabs({bool expanded = false}) {
    return List.generate(widget.items.length, (index) {
      final tab = _TabButton(
        item: widget.items[index],
        selected: index == _index,
        onTap: () => _select(index),
      );
      return [
        if (index != 0) Dimensions.hBox4,
        expanded ? Expanded(child: tab) : tab,
      ];
    }).expand((element) => element).toList();
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final KiteTabItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return KitePressable(
      onTap: onTap,
      semanticLabel: item.label,
      builder: (context, state) {
        final foreground = selected ? colors.textPrimary : colors.textSecondary;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          constraints: const BoxConstraints(
            minHeight: Dimensions.buttonHeightSm,
          ),
          padding: Dimensions.px12,
          decoration: ShapeDecoration(
            color: selected
                ? colors.card
                : state.hovered
                ? colors.soft(colors.textPrimary, amount: .04)
                : Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: Dimensions.rad8,
              side: BorderSide(
                color: state.focused ? colors.primary : Colors.transparent,
              ),
            ),
            shadows: selected
                ? [
                    BoxShadow(
                      color: colors.textPrimary.withValues(alpha: .05),
                      blurRadius: Dimensions.s8,
                      offset: const Offset(0, Dimensions.s2),
                    ),
                  ]
                : const [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (item.icon != null) ...[
                Icon(
                  item.icon,
                  size: Dimensions.iconSm,
                  color: selected ? colors.primary : colors.icon,
                ),
                Dimensions.hBox8,
              ],
              Text(
                item.label,
                style: context.typography.labelSmall.copyWith(
                  color: foreground,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
