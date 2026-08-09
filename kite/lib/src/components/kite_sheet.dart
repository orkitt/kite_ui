// Kite UI Components
// Copyright (c) 2026 Kite UI Contributors.
// Licensed under the MIT License. Keep this notice in substantial copies.
// Learn more: https://kite.orkitt.dev
import 'package:flutter/material.dart';

import '../design/design.dart';

class KiteSheet {
  KiteSheet._();

  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    String? title,
    String? description,
    bool isScrollControlled = true,
    bool useSafeArea = true,
  }) {
    final colors = context.kolors;

    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      useSafeArea: useSafeArea,
      backgroundColor: Colors.transparent,
      barrierColor: colors.textPrimary.withValues(alpha: .32),
      builder: (sheetContext) {
        final sheetColors = sheetContext.kolors;
        final type = sheetContext.typography;

        return Container(
          decoration: BoxDecoration(
            color: sheetColors.card,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(Dimensions.r24),
            ),
            border: Border(top: BorderSide(color: sheetColors.borderSoft)),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: Dimensions.s16,
              right: Dimensions.s16,
              bottom:
                  MediaQuery.viewInsetsOf(sheetContext).bottom + Dimensions.s16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Dimensions.gapV12,
                Align(
                  child: Container(
                    width: Dimensions.s40,
                    height: Dimensions.s4,
                    decoration: BoxDecoration(
                      color: sheetColors.borderStrong,
                      borderRadius: Dimensions.radFull,
                    ),
                  ),
                ),
                if (title != null) ...[
                  Dimensions.gapV20,
                  Text(title, style: type.h3),
                  if (description != null) ...[
                    Dimensions.gapV8,
                    Text(description, style: type.bodySmall),
                  ],
                ],
                Dimensions.gapV20,
                child,
              ],
            ),
          ),
        );
      },
    );
  }
}
