// Kite UI Components
// Copyright (c) 2026 Kite UI Contributors.
// Licensed under the MIT License. Keep this notice in substantial copies.
// Learn more: https://kite.orkitt.dev
import 'package:flutter/material.dart';

import '../design/design.dart';
import 'internal/kite_interactive.dart';

class KiteAccordionItem {
  const KiteAccordionItem({
    required this.title,
    required this.content,
    this.leading,
  });

  final String title;
  final Widget content;
  final Widget? leading;
}

class KiteAccordion extends StatefulWidget {
  const KiteAccordion({
    required this.items,
    super.key,
    this.initiallyExpandedIndex,
    this.allowMultiple = false,
  });

  final List<KiteAccordionItem> items;
  final int? initiallyExpandedIndex;
  final bool allowMultiple;

  @override
  State<KiteAccordion> createState() => _KiteAccordionState();
}

class _KiteAccordionState extends State<KiteAccordion> {
  final Set<int> _expanded = <int>{};

  @override
  void initState() {
    super.initState();
    final index = widget.initiallyExpandedIndex;
    if (index != null && index >= 0 && index < widget.items.length) {
      _expanded.add(index);
    }
  }

  void _toggle(int index) {
    setState(() {
      if (_expanded.remove(index)) return;
      if (!widget.allowMultiple) _expanded.clear();
      _expanded.add(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;

    return DecoratedBox(
      decoration: ShapeDecoration(
        color: colors.card,
        shape: Shapes.rounded16.copyWith(
          side: BorderSide(color: colors.borderSoft),
        ),
      ),
      child: ClipRRect(
        borderRadius: Dimensions.rad16,
        child: Column(
          children: [
            for (var i = 0; i < widget.items.length; i++) ...[
              _AccordionRow(
                item: widget.items[i],
                expanded: _expanded.contains(i),
                onTap: () => _toggle(i),
              ),
              if (i != widget.items.length - 1)
                Container(height: 1, color: colors.borderSoft),
            ],
          ],
        ),
      ),
    );
  }
}

class _AccordionRow extends StatelessWidget {
  const _AccordionRow({
    required this.item,
    required this.expanded,
    required this.onTap,
  });

  final KiteAccordionItem item;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;

    return Column(
      children: [
        KitePressable(
          onTap: onTap,
          semanticLabel: item.title,
          builder: (context, state) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              color: state.hovered ? colors.muted : Colors.transparent,
              padding: Dimensions.p16,
              child: Row(
                children: [
                  if (item.leading != null) ...[
                    IconTheme(
                      data: IconThemeData(
                        color: colors.icon,
                        size: Dimensions.iconMd,
                      ),
                      child: item.leading!,
                    ),
                    Dimensions.gapH12,
                  ],
                  Expanded(
                    child: Text(item.title, style: context.typography.title),
                  ),
                  Dimensions.gapH12,
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    width: Dimensions.s32,
                    height: Dimensions.s32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: expanded ? colors.primarySoft : colors.muted,
                      borderRadius: Dimensions.rad8,
                    ),
                    child: AnimatedRotation(
                      turns: expanded ? .5 : 0,
                      duration: const Duration(milliseconds: 180),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: Dimensions.iconSm,
                        color: expanded ? colors.primary : colors.icon,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox(width: double.infinity),
          secondChild: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(
              Dimensions.s16,
              Dimensions.zero,
              Dimensions.s16,
              Dimensions.s16,
            ),
            child: DefaultTextStyle(
              style: context.typography.body.copyWith(
                color: colors.textSecondary,
              ),
              child: item.content,
            ),
          ),
          crossFadeState: expanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 180),
          sizeCurve: Curves.easeOutCubic,
        ),
      ],
    );
  }
}
