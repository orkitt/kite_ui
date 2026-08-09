// Kite UI Components
// Copyright (c) 2026 Kite UI Contributors.
// Licensed under the MIT License. Keep this notice in substantial copies.
// Learn more: https://kite.orkitt.dev
import 'package:flutter/material.dart';

import '../design/design.dart';
import 'kite_button.dart';
import 'kite_calendar.dart';

class KiteDatePicker {
  KiteDatePicker._();

  static Future<DateTime?> show(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    String? helpText,
  }) async {
    final now = DateTime.now();
    DateTime selected = initialDate ?? now;

    return showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: context.kolors.textPrimary.withValues(alpha: .32),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            final colors = context.kolors;
            return SafeArea(
              top: false,
              child: Container(
                padding: Dimensions.p16,
                decoration: BoxDecoration(
                  color: colors.card,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(Dimensions.r24),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      child: Container(
                        width: Dimensions.s40,
                        height: Dimensions.s4,
                        decoration: BoxDecoration(
                          color: colors.borderStrong,
                          borderRadius: Dimensions.radFull,
                        ),
                      ),
                    ),
                    Dimensions.gapV20,
                    Text(
                      helpText ?? 'Choose date',
                      style: context.typography.h3,
                    ),
                    Dimensions.gapV16,
                    KiteCalendar(
                      selectedDate: selected,
                      firstDate: firstDate ?? DateTime(now.year - 100),
                      lastDate: lastDate ?? DateTime(now.year + 10, 12, 31),
                      onDateChanged: (value) =>
                          setState(() => selected = value),
                    ),
                    Dimensions.gapV16,
                    Row(
                      children: [
                        Expanded(
                          child: KiteButton(
                            label: 'Cancel',
                            variant: KiteButtonVariant.ghost,
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                        Dimensions.gapH8,
                        Expanded(
                          child: KiteButton(
                            label: 'Select',
                            onPressed: () =>
                                Navigator.of(context).pop(selected),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
