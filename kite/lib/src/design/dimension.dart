import 'package:flutter/material.dart';

/// Centralized application dimensions, paddings, radiuses, and layout gaps.
///
/// Based on an 4px grid system.
///
/// **Naming Conventions:**
/// - `s16`     → Raw spacing value (`double`)
/// - `r16`     → Raw radius value (`double`)
/// - `rad16`   → `BorderRadius`
/// - `p16`     → `EdgeInsets.all()`
/// - `px16`    → `EdgeInsets.symmetric(horizontal: ...)`
/// - `py16`    → `EdgeInsets.symmetric(vertical: ...)`
/// - `gapV16`  → Vertical gap (`SizedBox(height: ...)`)
/// - `gapH16`  → Horizontal gap (`SizedBox(width: ...)`)
abstract final class Dimensions {
  // ---------------------------------------------------------------------------
  // Zero Constants
  // ---------------------------------------------------------------------------

  static const double zero = 0.0;
  static const EdgeInsets pZero = EdgeInsets.zero;
  static const BorderRadius radZero = BorderRadius.zero;

  // ---------------------------------------------------------------------------
  // Raw Spacing Values (4px Grid)
  // ---------------------------------------------------------------------------

  static const double s2 = 2.0;
  static const double s4 = 4.0;
  static const double s8 = 8.0;
  static const double s12 = 12.0;
  static const double s16 = 16.0;
  static const double s20 = 20.0;
  static const double s24 = 24.0;
  static const double s32 = 32.0;
  static const double s40 = 40.0;
  static const double s48 = 48.0;
  static const double s64 = 64.0;

  // ---------------------------------------------------------------------------
  // Component & Touch Target Metrics
  // ---------------------------------------------------------------------------

  static const double touchTarget = 48.0;
  static const double iconSm = 16.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;

  // ---------------------------------------------------------------------------
  // Radius Double Values
  // ---------------------------------------------------------------------------

  static const double r4 = 4.0;
  static const double r8 = 8.0;
  static const double r12 = 12.0;
  static const double r16 = 16.0;
  static const double r20 = 20.0;
  static const double r24 = 24.0;
  static const double r32 = 32.0;
  static const double rFull = 9999.0;

  // ---------------------------------------------------------------------------
  // BorderRadius Objects
  // ---------------------------------------------------------------------------

  static const BorderRadius rad4 = BorderRadius.all(Radius.circular(r4));
  static const BorderRadius rad8 = BorderRadius.all(Radius.circular(r8));
  static const BorderRadius rad12 = BorderRadius.all(Radius.circular(r12));
  static const BorderRadius rad16 = BorderRadius.all(Radius.circular(r16));
  static const BorderRadius rad20 = BorderRadius.all(Radius.circular(r20));
  static const BorderRadius rad24 = BorderRadius.all(Radius.circular(r24));
  static const BorderRadius rad32 = BorderRadius.all(Radius.circular(r32));
  static const BorderRadius radFull = BorderRadius.all(Radius.circular(rFull));

  // ---------------------------------------------------------------------------
  // EdgeInsets: All Sides
  // ---------------------------------------------------------------------------

  static const EdgeInsets p4 = EdgeInsets.all(s4);
  static const EdgeInsets p8 = EdgeInsets.all(s8);
  static const EdgeInsets p12 = EdgeInsets.all(s12);
  static const EdgeInsets p16 = EdgeInsets.all(s16);
  static const EdgeInsets p20 = EdgeInsets.all(s20);
  static const EdgeInsets p24 = EdgeInsets.all(s24);
  static const EdgeInsets p32 = EdgeInsets.all(s32);

  // ---------------------------------------------------------------------------
  // EdgeInsets: Horizontal
  // ---------------------------------------------------------------------------

  static const EdgeInsets px8 = EdgeInsets.symmetric(horizontal: s8);
  static const EdgeInsets px12 = EdgeInsets.symmetric(horizontal: s12);
  static const EdgeInsets px16 = EdgeInsets.symmetric(horizontal: s16);
  static const EdgeInsets px20 = EdgeInsets.symmetric(horizontal: s20);
  static const EdgeInsets px24 = EdgeInsets.symmetric(horizontal: s24);
  static const EdgeInsets px32 = EdgeInsets.symmetric(horizontal: s32);

  // ---------------------------------------------------------------------------
  // EdgeInsets: Vertical
  // ---------------------------------------------------------------------------

  static const EdgeInsets py4 = EdgeInsets.symmetric(vertical: s4);
  static const EdgeInsets py8 = EdgeInsets.symmetric(vertical: s8);
  static const EdgeInsets py12 = EdgeInsets.symmetric(vertical: s12);
  static const EdgeInsets py16 = EdgeInsets.symmetric(vertical: s16);
  static const EdgeInsets py20 = EdgeInsets.symmetric(vertical: s20);
  static const EdgeInsets py24 = EdgeInsets.symmetric(vertical: s24);

  // ---------------------------------------------------------------------------
  // EdgeInsets: Asymmetric Pairings
  // ---------------------------------------------------------------------------

  static const EdgeInsets px16y8 = EdgeInsets.symmetric(
    horizontal: s16,
    vertical: s8,
  );
  static const EdgeInsets px16y12 = EdgeInsets.symmetric(
    horizontal: s16,
    vertical: s12,
  );
  static const EdgeInsets px20y16 = EdgeInsets.symmetric(
    horizontal: s20,
    vertical: s16,
  );

  // ---------------------------------------------------------------------------
  // Gaps: Vertical (Height)
  // ---------------------------------------------------------------------------

  static const SizedBox gapV4 = SizedBox(height: s4);
  static const SizedBox gapV8 = SizedBox(height: s8);
  static const SizedBox gapV12 = SizedBox(height: s12);
  static const SizedBox gapV16 = SizedBox(height: s16);
  static const SizedBox gapV20 = SizedBox(height: s20);
  static const SizedBox gapV24 = SizedBox(height: s24);
  static const SizedBox gapV32 = SizedBox(height: s32);
  static const SizedBox gapV40 = SizedBox(height: s40);
  static const SizedBox gapV48 = SizedBox(height: s48);
  static const SizedBox gapV64 = SizedBox(height: s64);

  // ---------------------------------------------------------------------------
  // Gaps: Horizontal (Width)
  // ---------------------------------------------------------------------------

  static const SizedBox gapH4 = SizedBox(width: s4);
  static const SizedBox gapH8 = SizedBox(width: s8);
  static const SizedBox gapH12 = SizedBox(width: s12);
  static const SizedBox gapH16 = SizedBox(width: s16);
  static const SizedBox gapH20 = SizedBox(width: s20);
  static const SizedBox gapH24 = SizedBox(width: s24);
  static const SizedBox gapH32 = SizedBox(width: s32);

  // ---------------------------------------------------------------------------
  // Navigation & Structure Heights / Widths
  // ---------------------------------------------------------------------------

  /// Standard Material 3 Navigation Bar height (Bottom Navigation).
  static const double navigationBarHeight = 80.0;

  /// Compact Navigation Rail width (collapsed state).
  static const double railWidth = 72.0;

  /// Extended Navigation Rail width (expanded state with labels).
  static const double railExtendedWidth = 256.0;

  /// Standard Top App Bar height.
  static const double appBarHeight = 64.0;

  /// Default screen padding (margin from edge of device).
  static const double screenPadding = 16.0;

  // ---------------------------------------------------------------------------
  // Control Heights
  // ---------------------------------------------------------------------------

  static const double buttonHeightSm = 36.0;
  static const double buttonHeightMd = 44.0;
  static const double buttonHeightLg = 52.0;

  // ---------------------------------------------------------------------------
  // Icon Sizes
  // ---------------------------------------------------------------------------
}

extension NumSpacingX on num {
  // ── Gaps (SizedBox) ────────────────────────────────────────────────────────
  /// Vertical space (`SizedBox(height: value)`)
  SizedBox get gapV => SizedBox(height: toDouble());

  /// Horizontal space (`SizedBox(width: value)`)
  SizedBox get gapH => SizedBox(width: toDouble());

  // ── Padding (EdgeInsets) ───────────────────────────────────────────────────
  /// All-side padding (`EdgeInsets.all(value)`)
  EdgeInsets get p => EdgeInsets.all(toDouble());

  /// Horizontal padding (`EdgeInsets.symmetric(horizontal: value)`)
  EdgeInsets get px => EdgeInsets.symmetric(horizontal: toDouble());

  /// Vertical padding (`EdgeInsets.symmetric(vertical: value)`)
  EdgeInsets get py => EdgeInsets.symmetric(vertical: toDouble());

  // ── Radius & BorderRadius ─────────────────────────────────────────────────
  /// Single `Radius` object (`Radius.circular(value)`)
  Radius get r => Radius.circular(toDouble());

  /// Complete `BorderRadius` object (`BorderRadius.circular(value)`)
  BorderRadius get rad => BorderRadius.circular(toDouble());
}

extension EdgeInsetsX on EdgeInsets {
  /// Combine paddings: `16.px + 8.py`
  EdgeInsets operator +(EdgeInsets other) {
    return EdgeInsets.only(
      left: left + other.left,
      top: top + other.top,
      right: right + other.right,
      bottom: bottom + other.bottom,
    );
  }
}
