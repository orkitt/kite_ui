// Kite UI Components
// Copyright (c) 2026 Kite UI Contributors.
// Licensed under the MIT License. Keep this notice in substantial copies.
// Learn more: https://kite.orkitt.dev
import 'package:flutter/material.dart';

import '../design/dimension.dart';
import '../design/kolors.dart';
import '../design/shapes.dart';
import '../design/typography.dart';
import 'kite_button.dart';

class KiteDialog {
  KiteDialog._();

  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required Widget content,
    Widget? icon,
    List<Widget> actions = const [],
    bool barrierDismissible = true,
    String? description,
  }) {
    final colors = context.colors;

    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: 'Dismiss',
      barrierColor: colors.textPrimary.withValues(alpha: .38),
      transitionDuration: const Duration(milliseconds: 180),
      pageBuilder: (dialogContext, _, _) {
        return SafeArea(
          child: Center(
            child: Padding(
              padding: Dimensions.p24,
              child: Material(
                color: Colors.transparent,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: _KiteDialogSurface(
                    title: title,
                    description: description,
                    icon: icon,
                    content: content,
                    actions: actions,
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, animation, _, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: .96, end: 1).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  static Future<bool> confirm(
    BuildContext context, {
    required String title,
    required String message,
    String cancelLabel = 'Cancel',
    String confirmLabel = 'Confirm',
    bool destructive = false,
  }) async {
    final result = await show<bool>(
      context,
      title: title,
      content: Text(
        message,
        style: context.typography.paragraph.copyWith(
          color: context.colors.textSecondary,
        ),
      ),
      actions: [
        KiteButton(
          label: cancelLabel,
          variant: KiteButtonVariant.ghost,
          onPressed: () => Navigator.of(context).pop(false),
        ),
        KiteButton(
          label: confirmLabel,
          variant: destructive
              ? KiteButtonVariant.danger
              : KiteButtonVariant.filled,
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
    return result ?? false;
  }
}

class _KiteDialogSurface extends StatelessWidget {
  const _KiteDialogSurface({
    required this.title,
    required this.content,
    required this.actions,
    this.description,
    this.icon,
  });

  final String title;
  final String? description;
  final Widget? icon;
  final Widget content;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.typography;

    return DecoratedBox(
      decoration: ShapeDecoration(
        color: colors.card,
        shape: Shapes.rounded20.copyWith(
          side: BorderSide(color: colors.borderSoft),
        ),
        shadows: [
          BoxShadow(
            color: colors.textPrimary.withValues(alpha: .12),
            blurRadius: Dimensions.s32,
            offset: const Offset(0, Dimensions.s12),
          ),
        ],
      ),
      child: Padding(
        padding: Dimensions.p24,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null) ...[
              Container(
                width: Dimensions.s40,
                height: Dimensions.s40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.primarySoft,
                  borderRadius: Dimensions.rad12,
                ),
                child: IconTheme(
                  data: IconThemeData(
                    color: colors.primary,
                    size: Dimensions.iconMd,
                  ),
                  child: icon!,
                ),
              ),
              Dimensions.vBox16,
            ],
            Text(title, style: type.section),
            if (description != null) ...[
              Dimensions.vBox8,
              Text(
                description!,
                style: type.paragraph.copyWith(color: colors.textSecondary),
              ),
            ],
            Dimensions.vBox20,
            content,
            if (actions.isNotEmpty) ...[
              Dimensions.vBox24,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  for (var i = 0; i < actions.length; i++) ...[
                    if (i != 0) Dimensions.hBox8,
                    actions[i],
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
