// Kite UI Components
// Copyright (c) 2026 Kite UI Contributors.
// Licensed under the MIT License. Keep this notice in substantial copies.
// Learn more: https://kite.orkitt.dev
import 'dart:async';

import 'package:flutter/material.dart';

import '../design/dimension.dart';
import '../design/kolors.dart';
import '../design/typography.dart';

class KiteTooltip extends StatefulWidget {
  const KiteTooltip({
    required this.message,
    required this.child,
    super.key,
    this.waitDuration = const Duration(milliseconds: 450),
  });

  final String message;
  final Widget child;
  final Duration waitDuration;

  @override
  State<KiteTooltip> createState() => _KiteTooltipState();
}

class _KiteTooltipState extends State<KiteTooltip> {
  final LayerLink _link = LayerLink();
  OverlayEntry? _entry;
  Timer? _timer;

  void _scheduleShow() {
    _timer?.cancel();
    _timer = Timer(widget.waitDuration, _show);
  }

  void _show() {
    if (_entry != null || !mounted) return;
    final overlay = Overlay.of(context);
    _entry = OverlayEntry(
      builder: (context) => IgnorePointer(
        child: CompositedTransformFollower(
          link: _link,
          showWhenUnlinked: false,
          targetAnchor: Alignment.topCenter,
          followerAnchor: Alignment.bottomCenter,
          offset: const Offset(0, -Dimensions.s8),
          child: UnconstrainedBox(
            child: _TooltipBubble(message: widget.message),
          ),
        ),
      ),
    );
    overlay.insert(_entry!);
  }

  void _hide() {
    _timer?.cancel();
    _timer = null;
    _entry?.remove();
    _entry = null;
  }

  @override
  void dispose() {
    _hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _scheduleShow(),
      onExit: (_) => _hide(),
      child: GestureDetector(
        onLongPressStart: (_) => _show(),
        onLongPressEnd: (_) => _hide(),
        child: CompositedTransformTarget(link: _link, child: widget.child),
      ),
    );
  }
}

class _TooltipBubble extends StatelessWidget {
  const _TooltipBubble({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: colors.textPrimary,
        shape: RoundedRectangleBorder(borderRadius: Dimensions.rad8),
        shadows: [
          BoxShadow(
            color: colors.textPrimary.withValues(alpha: .10),
            blurRadius: Dimensions.s8,
          ),
        ],
      ),
      child: Padding(
        padding: Dimensions.px8 + Dimensions.py4,
        child: Text(
          message,
          style: context.typography.caption.copyWith(color: colors.background),
        ),
      ),
    );
  }
}
