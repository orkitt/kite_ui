import 'package:flutter/material.dart';

import 'dimension.dart';

/// Built with Kite 🪁
/// Flutter foundations, architecture, and developer tooling.
/// Learn more: https://kite.orkitt.dev
/// Centralized shape standards for containers, cards, inputs, buttons, and sheets.
abstract final class Shapes {
  // ---------------------------------------------------------------------------
  // Outlined / Rounded Rectangle Borders (Buttons, Cards, Dialogs, Sheets)
  // ---------------------------------------------------------------------------

  static const rounded4 = RoundedRectangleBorder(borderRadius: Dimensions.rad4);
  static const rounded8 = RoundedRectangleBorder(borderRadius: Dimensions.rad8);
  static const rounded12 = RoundedRectangleBorder(
    borderRadius: Dimensions.rad12,
  );
  static const rounded16 = RoundedRectangleBorder(
    borderRadius: Dimensions.rad16,
  );
  static const rounded20 = RoundedRectangleBorder(
    borderRadius: Dimensions.rad20,
  );
  static const rounded24 = RoundedRectangleBorder(
    borderRadius: Dimensions.rad24,
  );
  static const roundedFull = RoundedRectangleBorder(
    borderRadius: Dimensions.radFull,
  );

  /// Custom radius `RoundedRectangleBorder`
  static RoundedRectangleBorder rounded(double radius) {
    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius));
  }

  // ---------------------------------------------------------------------------
  // Input Borders (TextField / Dropdown)
  // ---------------------------------------------------------------------------

  /// Creates a standard [OutlineInputBorder] with consistent radius defaults.
  static OutlineInputBorder inputBorder({
    required Color color,
    double width = 1.0,
    BorderRadius radius = Dimensions.rad12,
  }) {
    return OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: color, width: width),
    );
  }

  // ---------------------------------------------------------------------------
  // Container BoxDecorations
  // ---------------------------------------------------------------------------

  /// Standard crisp card container with subtle border.
  static BoxDecoration card({
    required Color color,
    required Color borderColor,
    BorderRadius radius = Dimensions.rad16,
    double borderWidth = 1.0,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: radius,
      border: Border.all(color: borderColor, width: borderWidth),
    );
  }

  /// Borderless container with filled background (e.g. muted sections, code blocks).
  static BoxDecoration subtle({
    required Color color,
    BorderRadius radius = Dimensions.rad12,
  }) {
    return BoxDecoration(color: color, borderRadius: radius);
  }

  /// Pill/Badge shape decoration with `radFull`.
  static BoxDecoration pill({
    required Color color,
    Color? borderColor,
    double borderWidth = 1.0,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: Dimensions.radFull,
      border: borderColor != null
          ? Border.all(color: borderColor, width: borderWidth)
          : null,
    );
  }

  /// Active/Focused outline card (e.g., selected plan, active item).
  static BoxDecoration focusCard({
    required Color color,
    required Color focusBorderColor,
    BorderRadius radius = Dimensions.rad16,
    double borderWidth = 1.5,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: radius,
      border: Border.all(color: focusBorderColor, width: borderWidth),
    );
  }
}

// Example(),
// Container(
//   padding: AppDimensions.p16,
//   decoration: AppShapes.card(
//     color: context.colors.card,
//     borderColor: context.colors.border,
//   ),
//   child: const Text('Standard Card'),
// )

// Container(
//   padding: AppDimensions.px12 + AppDimensions.py4,
//   decoration: AppShapes.pill(
//     color: context.colors.successSoft,
//     borderColor: context.colors.success.withOpacity(0.2),
//   ),
//   child: Text('Active', style: context.textTheme.caption),
// )

// InputDecorationTheme(
//   fillColor: context.colors.inputFill,
//   border: AppShapes.inputBorder(color: context.colors.border),
//   enabledBorder: AppShapes.inputBorder(color: context.colors.border),
//   focusedBorder: AppShapes.inputBorder(
//     color: context.colors.primary,
//     width: 1.5,
//   ),
//   errorBorder: AppShapes.inputBorder(color: context.colors.error),
// )

// Dialog
// showDialog(
//   context: context,
//   builder: (_) => AlertDialog(
//     shape: AppShapes.rounded20,
//     backgroundColor: context.colors.card,
//   ),
// );

// // Custom Button
// ElevatedButton(
//   style: ElevatedButton.styleFrom(
//     shape: AppShapes.rounded12,
//   ),
//   onPressed: () {},
//   child: const Text('Submit'),
// );
