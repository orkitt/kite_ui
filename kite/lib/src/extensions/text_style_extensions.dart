import 'package:flutter/material.dart';

/// Built with Kite 🪁
/// Flutter foundations, architecture, and developer tooling.
/// Learn more: https://kite.orkitt.dev
extension KiteTextStyleX on TextStyle {
  // Font Weight Modifiers
  TextStyle get bold => copyWith(fontWeight: FontWeight.w700);
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);
  TextStyle get regular => copyWith(fontWeight: FontWeight.w400);
  TextStyle get light => copyWith(fontWeight: FontWeight.w300);

  // Styling Modifiers
  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);
  TextStyle get underline => copyWith(decoration: TextDecoration.underline);
  TextStyle get lineThrough => copyWith(decoration: TextDecoration.lineThrough);

  // Color & Opacity Shortcuts
  TextStyle withColor(Color color) => copyWith(color: color);
  TextStyle withOpacity(double opacity) =>
      copyWith(color: color?.withValues(alpha: opacity));

  // Size Shortcut
  TextStyle withSize(double fontSize) => copyWith(fontSize: fontSize);
}
