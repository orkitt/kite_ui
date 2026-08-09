// Kite UI Components
// Copyright (c) 2026 Kite UI Contributors.
// Licensed under the MIT License. Keep this notice in substantial copies.
// Learn more: https://kite.orkitt.dev
import 'package:flutter/material.dart';

import '../design/design.dart';
import 'internal/kite_interactive.dart';

class KiteContextMenuItem<T> {
  const KiteContextMenuItem({
    required this.value,
    required this.label,
    this.icon,
    this.destructive = false,
    this.enabled = true,
  });

  final T value;
  final String label;
  final IconData? icon;
  final bool destructive;
  final bool enabled;
}

class KiteContextMenu<T> extends StatefulWidget {
  const KiteContextMenu({
    required this.child,
    required this.items,
    required this.onSelected,
    super.key,
  });

  final Widget child;
  final List<KiteContextMenuItem<T>> items;
  final ValueChanged<T> onSelected;

  @override
  State<KiteContextMenu<T>> createState() => _KiteContextMenuState<T>();
}

class _KiteContextMenuState<T> extends State<KiteContextMenu<T>> {
  OverlayEntry? _entry;

  @override
  void dispose() {
    _hide();
    super.dispose();
  }

  void _hide() {
    _entry?.remove();
    _entry = null;
  }

  void _show(Offset position) {
    _hide();
    final overlay = Overlay.of(context);
    final screen = MediaQuery.sizeOf(context);
    final width = screen.width < 320 ? screen.width - Dimensions.s32 : 280.0;
    final left = position.dx
        .clamp(
          Dimensions.s8,
          (screen.width - width - Dimensions.s8).clamp(
            Dimensions.s8,
            screen.width,
          ),
        )
        .toDouble();
    final estimatedHeight =
        widget.items.length * Dimensions.touchTarget + Dimensions.s16;
    final top = position.dy
        .clamp(
          Dimensions.s8,
          (screen.height - estimatedHeight - Dimensions.s8).clamp(
            Dimensions.s8,
            screen.height,
          ),
        )
        .toDouble();

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (overlayContext) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _hide,
                child: const ColoredBox(color: Colors.transparent),
              ),
            ),
            Positioned(
              left: left,
              top: top,
              width: width,
              child: Material(
                color: Colors.transparent,
                child: _MenuSurface<T>(
                  items: widget.items,
                  onSelected: (value) {
                    _hide();
                    widget.onSelected(value);
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
    _entry = entry;
    overlay.insert(entry);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onSecondaryTapDown: (details) => _show(details.globalPosition),
      onLongPressStart: (details) => _show(details.globalPosition),
      child: widget.child,
    );
  }
}

class _MenuSurface<T> extends StatelessWidget {
  const _MenuSurface({required this.items, required this.onSelected});

  final List<KiteContextMenuItem<T>> items;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;

    return DecoratedBox(
      decoration: ShapeDecoration(
        color: colors.card,
        shape: Shapes.rounded12.copyWith(
          side: BorderSide(color: colors.borderSoft),
        ),
        shadows: [
          BoxShadow(
            color: colors.textPrimary.withValues(alpha: .10),
            blurRadius: Dimensions.s24,
            offset: const Offset(0, Dimensions.s8),
          ),
        ],
      ),
      child: Padding(
        padding: Dimensions.p4,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final item in items)
              _MenuItem<T>(item: item, onSelected: onSelected),
          ],
        ),
      ),
    );
  }
}

class _MenuItem<T> extends StatelessWidget {
  const _MenuItem({required this.item, required this.onSelected});

  final KiteContextMenuItem<T> item;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;
    final foreground = !item.enabled
        ? colors.textDisabled
        : item.destructive
        ? colors.error
        : colors.textPrimary;

    return KitePressable(
      onTap: item.enabled ? () => onSelected(item.value) : null,
      semanticLabel: item.label,
      builder: (context, state) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          constraints: const BoxConstraints(minHeight: Dimensions.touchTarget),
          padding: Dimensions.px12,
          decoration: BoxDecoration(
            color: state.hovered
                ? item.destructive
                      ? colors.errorSoft
                      : colors.muted
                : Colors.transparent,
            borderRadius: Dimensions.rad8,
          ),
          child: Row(
            children: [
              if (item.icon != null) ...[
                Icon(item.icon, size: Dimensions.iconSm, color: foreground),
                Dimensions.gapH12,
              ],
              Expanded(
                child: Text(
                  item.label,
                  style: context.typography.body.copyWith(color: foreground),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
