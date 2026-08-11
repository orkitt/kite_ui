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

enum KiteCardVariant { surface, muted, outlined }

class KiteCard extends StatelessWidget {
  const KiteCard({
    this.child,
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.footer,
    this.padding = Dimensions.p16,
    this.onTap,
    this.variant = KiteCardVariant.surface,
  });

  final Widget? child;
  final String? title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final Widget? footer;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final KiteCardVariant variant;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    if (onTap == null) {
      return _surface(
        context,
        const KiteInteractionState(
          hovered: false,
          pressed: false,
          focused: false,
          enabled: true,
        ),
      );
    }

    return KitePressable(onTap: onTap, builder: _surface);
  }

  Widget _surface(BuildContext context, KiteInteractionState state) {
    final colors = context.colors;
    final type = context.typography;
    final baseColor = switch (variant) {
      KiteCardVariant.surface => colors.card,
      KiteCardVariant.muted => colors.muted,
      KiteCardVariant.outlined => colors.background,
    };
    final fill = state.pressed
        ? Color.lerp(baseColor, colors.textPrimary, .035)!
        : state.hovered
        ? Color.lerp(baseColor, colors.textPrimary, .02)!
        : baseColor;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      decoration: ShapeDecoration(
        color: fill,
        shape: Shapes.rounded16.copyWith(
          side: BorderSide(
            color: state.focused ? colors.primary : colors.borderSoft,
            width: state.focused ? 1.5 : 1,
          ),
        ),
        shadows: variant == KiteCardVariant.surface && state.hovered
            ? [
                BoxShadow(
                  color: colors.textPrimary.withValues(alpha: .05),
                  blurRadius: Dimensions.s16,
                  offset: const Offset(0, Dimensions.s4),
                ),
              ]
            : const [],
      ),
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null || leading != null || trailing != null) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (leading != null) ...[leading!, Dimensions.hBox12],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (title != null) Text(title!, style: type.title),
                        if (subtitle != null) ...[
                          Dimensions.vBox4,
                          Text(subtitle!, style: type.paragraph),
                        ],
                      ],
                    ),
                  ),
                  if (trailing != null) ...[Dimensions.hBox12, trailing!],
                ],
              ),
              Dimensions.vBox16,
            ],

            child ?? SizedBox(),
            if (footer != null) ...[
              Dimensions.vBox16,
              Container(height: 1, color: colors.borderSoft),
              Dimensions.vBox16,
              footer!,
            ],
          ],
        ),
      ),
    );
  }
}
