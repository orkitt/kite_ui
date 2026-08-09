// Kite UI Components
// Copyright (c) 2026 Kite UI Contributors.
// Licensed under the MIT License. Keep this notice in substantial copies.
// Learn more: https://kite.orkitt.dev
import 'package:flutter/material.dart';

import '../design/design.dart';

class KiteCarousel extends StatefulWidget {
  const KiteCarousel({
    required this.children,
    super.key,
    this.height = Dimensions.s64 * 3,
    this.viewportFraction = .92,
    this.showIndicator = true,
  });

  final List<Widget> children;
  final double height;
  final double viewportFraction;
  final bool showIndicator;

  @override
  State<KiteCarousel> createState() => _KiteCarouselState();
}

class _KiteCarouselState extends State<KiteCarousel> {
  late final PageController _controller;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: widget.viewportFraction);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;
    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.children.length,
            onPageChanged: (value) => setState(() => _index = value),
            itemBuilder: (context, index) =>
                Padding(padding: 4.px, child: widget.children[index]),
          ),
        ),
        if (widget.showIndicator && widget.children.length > 1) ...[
          Dimensions.gapV12,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.children.length, (index) {
              final selected = index == _index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: selected ? Dimensions.s20 : Dimensions.s8,
                height: Dimensions.s8,
                margin: 4.px,
                decoration: BoxDecoration(
                  color: selected ? colors.primary : colors.borderStrong,
                  borderRadius: Dimensions.radFull,
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}
