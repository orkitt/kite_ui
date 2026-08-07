// Kite UI Components
// Copyright (c) 2026 Kite UI Contributors.
// Licensed under the MIT License. Keep this notice in substantial copies.

import 'package:flutter/material.dart';

import '../design/design.dart';
import 'internal/kite_interactive.dart';

class KiteDropdown<T> extends StatelessWidget {
  const KiteDropdown({
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    super.key,
    this.value,
    this.label,
    this.hint,
    this.prefixIcon,
    this.enabled = true,
    this.sheetTitle,
  });

  final List<T> items;
  final String Function(T item) itemLabel;
  final ValueChanged<T?> onChanged;
  final T? value;
  final String? label;
  final String? hint;
  final Widget? prefixIcon;
  final bool enabled;
  final String? sheetTitle;

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;
    final type = context.typography;
    final selectedLabel = value == null ? null : itemLabel(value as T);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: type.labelSmall),
          Dimensions.gapV8,
        ],
        KitePressable(
          semanticLabel: label ?? hint,
          onTap: enabled ? () => _showSheet(context) : null,
          builder: (context, state) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 140),
              constraints: const BoxConstraints(
                minHeight: Dimensions.buttonHeightLg,
              ),
              padding: Dimensions.px12,
              decoration: ShapeDecoration(
                color: enabled ? colors.inputFill : colors.muted,
                shape: Shapes.rounded12.copyWith(
                  side: BorderSide(
                    color: state.focused
                        ? colors.primary
                        : state.hovered
                        ? colors.borderStrong
                        : colors.border,
                    width: state.focused ? 1.5 : 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  if (prefixIcon != null) ...[
                    IconTheme(
                      data: IconThemeData(
                        color: colors.icon,
                        size: Dimensions.iconSm,
                      ),
                      child: prefixIcon!,
                    ),
                    Dimensions.gapH12,
                  ],
                  Expanded(
                    child: Text(
                      selectedLabel ?? hint ?? 'Select',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: type.body.copyWith(
                        color: selectedLabel == null
                            ? colors.textDisabled
                            : colors.textPrimary,
                      ),
                    ),
                  ),
                  Dimensions.gapH12,
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 140),
                    turns: state.pressed ? .5 : 0,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: Dimensions.iconMd,
                      color: colors.icon,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Future<void> _showSheet(BuildContext context) async {
    final result = await showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: context.kolors.textPrimary.withValues(alpha: .32),
      isScrollControlled: true,
      builder: (sheetContext) {
        final colors = sheetContext.kolors;
        final type = sheetContext.typography;

        return SafeArea(
          top: false,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(sheetContext).height * .72,
            ),
            decoration: ShapeDecoration(
              color: colors.card,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(Dimensions.r24),
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Dimensions.gapV12,
                Container(
                  width: Dimensions.s40,
                  height: Dimensions.s4,
                  decoration: BoxDecoration(
                    color: colors.borderStrong,
                    borderRadius: Dimensions.radFull,
                  ),
                ),
                Padding(
                  padding: Dimensions.p16,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          sheetTitle ?? label ?? 'Select option',
                          style: type.h3,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(sheetContext).pop(),
                        child: SizedBox.square(
                          dimension: Dimensions.s32,
                          child: Icon(
                            Icons.close_rounded,
                            size: Dimensions.iconSm,
                            color: colors.icon,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(height: 1, color: colors.borderSoft),
                Flexible(
                  child: ListView.separated(
                    padding: Dimensions.p8,
                    shrinkWrap: true,
                    itemCount: items.length,
                    separatorBuilder: (_, _) => Dimensions.gapV4,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final selected = item == value;
                      return KitePressable(
                        onTap: () => Navigator.of(sheetContext).pop(item),
                        semanticLabel: itemLabel(item),
                        builder: (context, state) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 120),
                            padding: Dimensions.px12 + Dimensions.py12,
                            decoration: BoxDecoration(
                              color: selected
                                  ? colors.primarySoft
                                  : state.hovered
                                  ? colors.muted
                                  : Colors.transparent,
                              borderRadius: Dimensions.rad12,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    itemLabel(item),
                                    style: type.body.copyWith(
                                      color: selected
                                          ? colors.primary
                                          : colors.textPrimary,
                                      fontWeight: selected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                    ),
                                  ),
                                ),
                                if (selected)
                                  Icon(
                                    Icons.check_rounded,
                                    size: Dimensions.iconSm,
                                    color: colors.primary,
                                  ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Dimensions.gapV8,
              ],
            ),
          ),
        );
      },
    );

    if (result != null) onChanged(result);
  }
}
