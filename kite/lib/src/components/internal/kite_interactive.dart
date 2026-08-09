// Kite UI Components
// Copyright (c) 2026 Kite UI Contributors.
// Licensed under the MIT License. Keep this notice in substantial copies.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

@immutable
class KiteInteractionState {
  const KiteInteractionState({
    required this.hovered,
    required this.pressed,
    required this.focused,
    required this.enabled,
  });

  final bool hovered;
  final bool pressed;
  final bool focused;
  final bool enabled;
}

class KitePressable extends StatefulWidget {
  const KitePressable({
    required this.builder,
    required this.onTap,
    super.key,
    this.semanticLabel,
    this.autofocus = false,
    this.focusNode,
    this.mouseCursor,
  });

  final Widget Function(BuildContext context, KiteInteractionState state)
  builder;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final bool autofocus;
  final FocusNode? focusNode;
  final MouseCursor? mouseCursor;

  @override
  State<KitePressable> createState() => _KitePressableState();
}

class _KitePressableState extends State<KitePressable> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  bool get _enabled => widget.onTap != null;

  void _activate() {
    if (_enabled) widget.onTap!.call();
  }

  @override
  Widget build(BuildContext context) {
    final state = KiteInteractionState(
      hovered: _hovered,
      pressed: _pressed,
      focused: _focused,
      enabled: _enabled,
    );

    return Semantics(
      button: true,
      enabled: _enabled,
      label: widget.semanticLabel,
      onTap: _enabled ? _activate : null,
      child: MouseRegion(
        cursor:
            widget.mouseCursor ??
            (_enabled ? SystemMouseCursors.click : SystemMouseCursors.basic),
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() {
          _hovered = false;
          _pressed = false;
        }),
        child: Focus(
          autofocus: widget.autofocus,
          focusNode: widget.focusNode,
          onFocusChange: (value) => setState(() => _focused = value),
          onKeyEvent: (_, event) {
            if (!_enabled || event is! KeyDownEvent) {
              return KeyEventResult.ignored;
            }
            if (event.logicalKey == LogicalKeyboardKey.enter ||
                event.logicalKey == LogicalKeyboardKey.space) {
              _activate();
              return KeyEventResult.handled;
            }
            return KeyEventResult.ignored;
          },
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _enabled ? _activate : null,
            onTapDown: _enabled ? (_) => setState(() => _pressed = true) : null,
            onTapUp: _enabled ? (_) => setState(() => _pressed = false) : null,
            onTapCancel: _enabled
                ? () => setState(() => _pressed = false)
                : null,
            child: widget.builder(context, state),
          ),
        ),
      ),
    );
  }
}
