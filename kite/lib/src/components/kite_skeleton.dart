// Kite UI Components
// Copyright (c) 2026 Kite UI Contributors.
// Licensed under the MIT License. Keep this notice in substantial copies.

import 'package:flutter/material.dart';

import '../design/design.dart';

class KiteSkeleton extends StatefulWidget {
  const KiteSkeleton({
    super.key,
    this.width = double.infinity,
    this.height = Dimensions.s16,
    this.borderRadius = Dimensions.rad8,
  });

  final double width;
  final double height;
  final BorderRadius borderRadius;

  @override
  State<KiteSkeleton> createState() => _KiteSkeletonState();
}

class _KiteSkeletonState extends State<KiteSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
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

    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final stop = (_controller.value * 2) - .5;
            return DecoratedBox(
              decoration: BoxDecoration(
                color: colors.muted,
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [colors.muted, colors.borderSoft, colors.muted],
                  stops: [
                    (stop - .35).clamp(0.0, 1.0).toDouble(),
                    stop.clamp(0.0, 1.0).toDouble(),
                    (stop + .35).clamp(0.0, 1.0).toDouble(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class KiteSkeletonText extends StatelessWidget {
  const KiteSkeletonText({super.key, this.lines = 3});

  final int lines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(lines, (index) {
        final last = index == lines - 1;
        return Padding(
          padding: EdgeInsets.only(
            bottom: last ? Dimensions.zero : Dimensions.s8,
          ),
          child: FractionallySizedBox(
            widthFactor: last ? .68 : 1,
            child: const KiteSkeleton(height: Dimensions.s12),
          ),
        );
      }),
    );
  }
}
