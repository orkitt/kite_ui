// Kite UI Components
// Copyright (c) 2026 Kite UI Contributors.
// Licensed under the MIT License. Keep this notice in substantial copies.

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../design/design.dart';

class KiteProgress extends StatefulWidget {
  const KiteProgress({
    super.key,
    this.value,
    this.label,
    this.showValue = false,
  });

  final double? value;
  final String? label;
  final bool showValue;

  @override
  State<KiteProgress> createState() => _KiteProgressState();
}

class _KiteProgressState extends State<KiteProgress>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.value == null) {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1200),
      )..repeat();
    }
  }

  @override
  void didUpdateWidget(covariant KiteProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      if (widget.value == null && _controller == null) {
        _controller = AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 1200),
        )..repeat();
      } else if (widget.value != null) {
        _controller?.dispose();
        _controller = null;
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;
    final normalized = widget.value?.clamp(0.0, 1.0).toDouble();

    final bar = ClipRRect(
      borderRadius: Dimensions.radFull,
      child: SizedBox(
        height: Dimensions.s8,
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (normalized != null) {
              return Stack(
                children: [
                  ColoredBox(color: colors.muted),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 260),
                    curve: Curves.easeOutCubic,
                    width: constraints.maxWidth * normalized,
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: Dimensions.radFull,
                    ),
                  ),
                ],
              );
            }

            return AnimatedBuilder(
              animation: _controller!,
              builder: (context, _) {
                final trackWidth = constraints.maxWidth * .32;
                final available = constraints.maxWidth + trackWidth;
                final left = (_controller!.value * available) - trackWidth;
                return Stack(
                  children: [
                    ColoredBox(color: colors.muted),
                    Positioned(
                      left: left,
                      width: trackWidth,
                      top: 0,
                      bottom: 0,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: colors.primary,
                          borderRadius: Dimensions.radFull,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null || widget.showValue) ...[
          Row(
            children: [
              if (widget.label != null)
                Expanded(
                  child: Text(
                    widget.label!,
                    style: context.typography.labelSmall,
                  ),
                ),
              if (widget.showValue && normalized != null)
                Text(
                  '${(normalized * 100).round()}%',
                  style: context.typography.caption,
                ),
            ],
          ),
          Dimensions.gapV8,
        ],
        bar,
      ],
    );
  }
}

class KiteCircularProgress extends StatefulWidget {
  const KiteCircularProgress({
    super.key,
    this.value,
    this.size = Dimensions.s40,
  });

  final double? value;
  final double size;

  @override
  State<KiteCircularProgress> createState() => _KiteCircularProgressState();
}

class _KiteCircularProgressState extends State<KiteCircularProgress>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;
    return SizedBox.square(
      dimension: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => CustomPaint(
          painter: _CircularProgressPainter(
            value: widget.value,
            rotation: widget.value == null ? _controller.value : 0,
            trackColor: colors.muted,
            progressColor: colors.primary,
          ),
        ),
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  const _CircularProgressPainter({
    required this.value,
    required this.rotation,
    required this.trackColor,
    required this.progressColor,
  });

  final double? value;
  final double rotation;
  final Color trackColor;
  final Color progressColor;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Dimensions.s4;
    final rect = Offset.zero & size;
    final arcRect = rect.deflate(stroke / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    paint.color = trackColor;
    canvas.drawArc(arcRect, 0, math.pi * 2, false, paint);

    paint.color = progressColor;
    final start = -math.pi / 2 + rotation * math.pi * 2;
    final normalized = value?.clamp(0.0, 1.0).toDouble() ?? .28;
    final sweep = normalized * math.pi * 2;
    canvas.drawArc(arcRect, start, sweep, false, paint);
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter oldDelegate) =>
      oldDelegate.value != value ||
      oldDelegate.rotation != rotation ||
      oldDelegate.trackColor != trackColor ||
      oldDelegate.progressColor != progressColor;
}
