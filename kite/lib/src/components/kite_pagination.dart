// Kite UI Components
// Copyright (c) 2026 Kite UI Contributors.
// Licensed under the MIT License. Keep this notice in substantial copies.
// Learn more: https://kite.orkitt.dev
import 'package:flutter/material.dart';

import '../design/dimension.dart';
import '../design/kolors.dart';
import '../design/typography.dart';
import 'internal/kite_interactive.dart';

class KitePagination extends StatelessWidget {
  const KitePagination({
    required this.page,
    required this.totalPages,
    required this.onPageChanged,
    super.key,
  });

  final int page;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 0) return const SizedBox.shrink();
    final visible = _visiblePages();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _PageButton(
          icon: Icons.chevron_left_rounded,
          enabled: page > 1,
          onTap: () => onPageChanged(page - 1),
        ),
        Dimensions.hBox8,
        for (var i = 0; i < visible.length; i++) ...[
          _PageButton(
            label: '${visible[i]}',
            selected: visible[i] == page,
            onTap: () => onPageChanged(visible[i]),
          ),
          if (i != visible.length - 1) Dimensions.hBox4,
        ],
        Dimensions.hBox8,
        _PageButton(
          icon: Icons.chevron_right_rounded,
          enabled: page < totalPages,
          onTap: () => onPageChanged(page + 1),
        ),
      ],
    );
  }

  List<int> _visiblePages() {
    if (totalPages <= 5) return List.generate(totalPages, (index) => index + 1);
    final start = (page - 2).clamp(1, totalPages - 4).toInt();
    return List.generate(5, (index) => start + index);
  }
}

class _PageButton extends StatelessWidget {
  const _PageButton({
    required this.onTap,
    this.label,
    this.icon,
    this.selected = false,
    this.enabled = true,
  });

  final VoidCallback onTap;
  final String? label;
  final IconData? icon;
  final bool selected;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return KitePressable(
      onTap: enabled ? onTap : null,
      semanticLabel: label,
      builder: (context, state) {
        final foreground = !state.enabled
            ? colors.textDisabled
            : selected
            ? colors.primary
            : colors.textSecondary;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: Dimensions.s40,
          height: Dimensions.s40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected
                ? colors.primarySoft
                : state.hovered
                ? colors.muted
                : Colors.transparent,
            borderRadius: Dimensions.rad12,
            border: Border.all(
              color: state.focused
                  ? colors.primary
                  : selected
                  ? colors.primarySoft
                  : colors.borderSoft,
            ),
          ),
          child: icon != null
              ? Icon(icon, size: Dimensions.iconSm, color: foreground)
              : Text(
                  label!,
                  style: context.typography.labelSmall.copyWith(
                    color: foreground,
                  ),
                ),
        );
      },
    );
  }
}
