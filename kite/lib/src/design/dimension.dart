import 'package:flutter/material.dart';

/// Built with Kite 🪁
/// Flutter foundations, architecture, and developer tooling.
/// Learn more: https://kite.orkitt.dev
///
/// Centralized application dimensions, paddings, radiuses, and layout gaps.
///
/// Based primarily on a 4px grid system.
///
/// Naming conventions:
/// - `s16`    → Raw spacing value
/// - `r16`    → Raw radius value
/// - `rad16`  → BorderRadius
/// - `p16`    → EdgeInsets.all()
/// - `px16`   → Horizontal padding
/// - `py16`   → Vertical padding
/// - `vBox16` → Vertical gap
/// - `hBox16` → Horizontal gap
abstract final class Dimensions {
  // ===========================================================================
  // ZERO
  // ===========================================================================

  static const double zero = 0.0;

  static const EdgeInsets pZero = EdgeInsets.zero;

  static const BorderRadius radZero = BorderRadius.zero;

  // ===========================================================================
  // RAW SPACING VALUES
  // ===========================================================================

  static const double s2 = 2.0;
  static const double s4 = 4.0;
  static const double s8 = 8.0;
  static const double s12 = 12.0;
  static const double s16 = 16.0;
  static const double s20 = 20.0;
  static const double s24 = 24.0;

  static const double s28 = 28.0;

  static const double s32 = 32.0;

  static const double s36 = 36.0;

  static const double s40 = 40.0;

  static const double s44 = 44.0;

  static const double s48 = 48.0;

  static const double s52 = 52.0;

  static const double s56 = 56.0;

  static const double s60 = 60.0;

  static const double s64 = 64.0;

  static const double s72 = 72.0;

  static const double s80 = 80.0;

  static const double s88 = 88.0;

  static const double s96 = 96.0;

  static const double s104 = 104.0;
  static const double s112 = 112.0;
  static const double s120 = 120.0;
  static const double s128 = 128.0;

  // ===========================================================================
  // COMPONENT & TOUCH TARGET METRICS
  // ===========================================================================

  static const double touchTarget = 48.0;

  static const double touchTargetSm = 40.0;
  static const double touchTargetLg = 56.0;

  // ---------------------------------------------------------------------------
  // Icons
  // ---------------------------------------------------------------------------

  static const double iconXs = 12.0;
  static const double iconSm = 16.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 40.0;
  static const double iconXxl = 48.0;

  // ---------------------------------------------------------------------------
  // Avatar / profile sizes
  // ---------------------------------------------------------------------------

  static const double avatarXs = 24.0;
  static const double avatarSm = 32.0;
  static const double avatarMd = 40.0;
  static const double avatarLg = 48.0;
  static const double avatarXl = 64.0;
  static const double avatarXxl = 96.0;

  // ---------------------------------------------------------------------------
  // Common indicators
  // ---------------------------------------------------------------------------

  static const double indicatorSm = 16.0;
  static const double indicatorMd = 24.0;
  static const double indicatorLg = 32.0;

  // ===========================================================================
  // RADIUS DOUBLE VALUES
  // ===========================================================================

  static const double r4 = 4.0;
  static const double r8 = 8.0;
  static const double r12 = 12.0;
  static const double r16 = 16.0;
  static const double r20 = 20.0;
  static const double r24 = 24.0;

  static const double r28 = 28.0;

  static const double r32 = 32.0;

  static const double r40 = 40.0;
  static const double r48 = 48.0;

  static const double rFull = 9999.0;

  // ===========================================================================
  // BORDER RADIUS OBJECTS
  // ===========================================================================

  static const BorderRadius rad4 = BorderRadius.all(Radius.circular(r4));

  static const BorderRadius rad8 = BorderRadius.all(Radius.circular(r8));

  static const BorderRadius rad12 = BorderRadius.all(Radius.circular(r12));

  static const BorderRadius rad16 = BorderRadius.all(Radius.circular(r16));

  static const BorderRadius rad20 = BorderRadius.all(Radius.circular(r20));

  static const BorderRadius rad24 = BorderRadius.all(Radius.circular(r24));

  static const BorderRadius rad28 = BorderRadius.all(Radius.circular(r28));

  static const BorderRadius rad32 = BorderRadius.all(Radius.circular(r32));

  static const BorderRadius rad40 = BorderRadius.all(Radius.circular(r40));

  static const BorderRadius rad48 = BorderRadius.all(Radius.circular(r48));

  static const BorderRadius radFull = BorderRadius.all(Radius.circular(rFull));

  // ===========================================================================
  // EDGE INSETS — ALL SIDES
  // ===========================================================================

  static const EdgeInsets p2 = EdgeInsets.all(s2);
  static const EdgeInsets p4 = EdgeInsets.all(s4);
  static const EdgeInsets p8 = EdgeInsets.all(s8);
  static const EdgeInsets p12 = EdgeInsets.all(s12);
  static const EdgeInsets p16 = EdgeInsets.all(s16);
  static const EdgeInsets p20 = EdgeInsets.all(s20);
  static const EdgeInsets p24 = EdgeInsets.all(s24);

  static const EdgeInsets p28 = EdgeInsets.all(s28);

  static const EdgeInsets p32 = EdgeInsets.all(s32);

  static const EdgeInsets p40 = EdgeInsets.all(s40);
  static const EdgeInsets p48 = EdgeInsets.all(s48);

  // ===========================================================================
  // EDGE INSETS — HORIZONTAL
  // ===========================================================================

  static const EdgeInsets px4 = EdgeInsets.symmetric(horizontal: s4);

  static const EdgeInsets px8 = EdgeInsets.symmetric(horizontal: s8);

  static const EdgeInsets px12 = EdgeInsets.symmetric(horizontal: s12);

  static const EdgeInsets px16 = EdgeInsets.symmetric(horizontal: s16);

  static const EdgeInsets px20 = EdgeInsets.symmetric(horizontal: s20);

  static const EdgeInsets px24 = EdgeInsets.symmetric(horizontal: s24);

  static const EdgeInsets px28 = EdgeInsets.symmetric(horizontal: s28);

  static const EdgeInsets px32 = EdgeInsets.symmetric(horizontal: s32);

  static const EdgeInsets px40 = EdgeInsets.symmetric(horizontal: s40);

  static const EdgeInsets px48 = EdgeInsets.symmetric(horizontal: s48);

  // ===========================================================================
  // EDGE INSETS — VERTICAL
  // ===========================================================================

  static const EdgeInsets py4 = EdgeInsets.symmetric(vertical: s4);

  static const EdgeInsets py8 = EdgeInsets.symmetric(vertical: s8);

  static const EdgeInsets py12 = EdgeInsets.symmetric(vertical: s12);

  static const EdgeInsets py16 = EdgeInsets.symmetric(vertical: s16);

  static const EdgeInsets py20 = EdgeInsets.symmetric(vertical: s20);

  static const EdgeInsets py24 = EdgeInsets.symmetric(vertical: s24);

  static const EdgeInsets py28 = EdgeInsets.symmetric(vertical: s28);

  static const EdgeInsets py32 = EdgeInsets.symmetric(vertical: s32);

  static const EdgeInsets py40 = EdgeInsets.symmetric(vertical: s40);

  static const EdgeInsets py48 = EdgeInsets.symmetric(vertical: s48);

  // ===========================================================================
  // EDGE INSETS — ASYMMETRIC PAIRINGS
  // ===========================================================================

  static const EdgeInsets px8y4 = EdgeInsets.symmetric(
    horizontal: s8,
    vertical: s4,
  );

  static const EdgeInsets px12y8 = EdgeInsets.symmetric(
    horizontal: s12,
    vertical: s8,
  );

  static const EdgeInsets px16y4 = EdgeInsets.symmetric(
    horizontal: s16,
    vertical: s4,
  );

  static const EdgeInsets px16y8 = EdgeInsets.symmetric(
    horizontal: s16,
    vertical: s8,
  );

  static const EdgeInsets px16y12 = EdgeInsets.symmetric(
    horizontal: s16,
    vertical: s12,
  );

  static const EdgeInsets px16y20 = EdgeInsets.symmetric(
    horizontal: s16,
    vertical: s20,
  );

  static const EdgeInsets px20y8 = EdgeInsets.symmetric(
    horizontal: s20,
    vertical: s8,
  );

  static const EdgeInsets px20y12 = EdgeInsets.symmetric(
    horizontal: s20,
    vertical: s12,
  );

  static const EdgeInsets px20y16 = EdgeInsets.symmetric(
    horizontal: s20,
    vertical: s16,
  );

  static const EdgeInsets px24y8 = EdgeInsets.symmetric(
    horizontal: s24,
    vertical: s8,
  );

  static const EdgeInsets px24y12 = EdgeInsets.symmetric(
    horizontal: s24,
    vertical: s12,
  );

  static const EdgeInsets px24y16 = EdgeInsets.symmetric(
    horizontal: s24,
    vertical: s16,
  );

  static const EdgeInsets px24y20 = EdgeInsets.symmetric(
    horizontal: s24,
    vertical: s20,
  );

  static const EdgeInsets px32y16 = EdgeInsets.symmetric(
    horizontal: s32,
    vertical: s16,
  );

  static const EdgeInsets px32y24 = EdgeInsets.symmetric(
    horizontal: s32,
    vertical: s24,
  );

  // ===========================================================================
  // EDGE INSETS — COMMON SCREEN PATTERNS
  // ===========================================================================

  /// Default mobile page content padding.
  static const EdgeInsets screenInsets = EdgeInsets.symmetric(horizontal: s16);

  /// Slightly more spacious page padding.
  static const EdgeInsets screenInsetsComfortable = EdgeInsets.symmetric(
    horizontal: s20,
  );

  /// Common card internal padding.
  static const EdgeInsets cardPadding = EdgeInsets.all(s16);

  /// Spacious card internal padding.
  static const EdgeInsets cardPaddingLg = EdgeInsets.all(s20);

  /// Dialog / modal internal padding.
  static const EdgeInsets dialogPadding = EdgeInsets.all(s24);

  /// Bottom sheet content padding.
  static const EdgeInsets bottomSheetPadding = EdgeInsets.fromLTRB(
    s20,
    s20,
    s20,
    s24,
  );

  // ===========================================================================
  // VERTICAL GAPS
  // ===========================================================================

  static const SizedBox vBox2 = SizedBox(height: s2);
  static const SizedBox vBox4 = SizedBox(height: s4);
  static const SizedBox vBox8 = SizedBox(height: s8);
  static const SizedBox vBox12 = SizedBox(height: s12);
  static const SizedBox vBox16 = SizedBox(height: s16);
  static const SizedBox vBox20 = SizedBox(height: s20);
  static const SizedBox vBox24 = SizedBox(height: s24);

  static const SizedBox vBox28 = SizedBox(height: s28);

  static const SizedBox vBox32 = SizedBox(height: s32);

  static const SizedBox vBox36 = SizedBox(height: s36);

  static const SizedBox vBox40 = SizedBox(height: s40);

  static const SizedBox vBox48 = SizedBox(height: s48);
  static const SizedBox vBox56 = SizedBox(height: s56);
  static const SizedBox vBox64 = SizedBox(height: s64);
  static const SizedBox vBox72 = SizedBox(height: s72);
  static const SizedBox vBox80 = SizedBox(height: s80);
  static const SizedBox vBox96 = SizedBox(height: s96);

  // ===========================================================================
  // HORIZONTAL GAPS
  // ===========================================================================

  static const SizedBox hBox2 = SizedBox(width: s2);
  static const SizedBox hBox4 = SizedBox(width: s4);
  static const SizedBox hBox8 = SizedBox(width: s8);
  static const SizedBox hBox12 = SizedBox(width: s12);
  static const SizedBox hBox16 = SizedBox(width: s16);
  static const SizedBox hBox20 = SizedBox(width: s20);
  static const SizedBox hBox24 = SizedBox(width: s24);

  static const SizedBox hBox28 = SizedBox(width: s28);

  static const SizedBox hBox32 = SizedBox(width: s32);
  static const SizedBox hBox40 = SizedBox(width: s40);
  static const SizedBox hBox48 = SizedBox(width: s48);
  static const SizedBox hBox56 = SizedBox(width: s56);
  static const SizedBox hBox64 = SizedBox(width: s64);

  // ===========================================================================
  // BORDERS / DIVIDERS / STROKES
  // ===========================================================================

  static const double borderThin = 0.5;
  static const double borderDefault = 1.0;
  static const double borderStrong = 2.0;

  static const double dividerThickness = 1.0;

  static const double progressStrokeSm = 2.0;
  static const double progressStrokeMd = 3.0;
  static const double progressStrokeLg = 4.0;

  // ===========================================================================
  // NAVIGATION & STRUCTURE HEIGHTS / WIDTHS
  // ===========================================================================

  /// Standard Material 3 Navigation Bar height.
  static const double navigationBarHeight = 80.0;

  /// More compact custom bottom navigation.
  static const double navigationBarHeightCompact = 64.0;

  /// Standard navigation rail width.
  static const double railWidth = 72.0;

  /// Extended navigation rail width.
  static const double railExtendedWidth = 256.0;

  /// Standard top app bar height.
  static const double appBarHeight = 64.0;

  /// Flutter's standard toolbar height.
  static const double toolbarHeight = 56.0;

  /// Default screen padding.
  static const double screenPadding = 16.0;

  /// Comfortable screen padding for larger phones/tablets.
  static const double screenPaddingLg = 24.0;

  /// Common drawer width.
  static const double drawerWidth = 304.0;

  /// Compact sidebar width.
  static const double sidebarWidth = 280.0;

  // ===========================================================================
  // CONTROL HEIGHTS
  // ===========================================================================

  static const double buttonHeightSm = 36.0;
  static const double buttonHeightMd = 44.0;
  static const double buttonHeightLg = 52.0;

  static const double buttonHeightXl = 56.0;

  static const double inputHeightSm = 40.0;
  static const double inputHeightMd = 48.0;
  static const double inputHeightLg = 56.0;

  static const double chipHeight = 32.0;

  static const double segmentedControlHeight = 44.0;

  // ===========================================================================
  // COMMON COMPONENT SIZES
  // ===========================================================================

  static const double checkboxSize = 20.0;
  static const double radioSize = 20.0;
  static const double switchHeight = 32.0;

  static const double badgeSm = 16.0;
  static const double badgeMd = 20.0;
  static const double badgeLg = 24.0;

  static const double fabSm = 40.0;
  static const double fabMd = 56.0;
  static const double fabLg = 64.0;

  // ===========================================================================
  // CONTENT WIDTH CONSTRAINTS
  // ===========================================================================

  /// Useful for authentication/forms on tablet and desktop.
  static const double formMaxWidth = 520.0;

  /// Common dialog max width.
  static const double dialogMaxWidth = 480.0;

  /// Standard content width.
  static const double contentMaxWidth = 1200.0;

  /// Narrow readable content.
  static const double readableContentMaxWidth = 720.0;

  // ===========================================================================
  // RESPONSIVE BREAKPOINTS
  // ===========================================================================

  // static const double mobileBreakpoint = 600.0;
  // static const double tabletBreakpoint = 840.0;
  // static const double desktopBreakpoint = 1200.0;
  // static const double wideDesktopBreakpoint = 1440.0;

  // ===========================================================================
  // IMAGE / THUMBNAIL SIZES
  // ===========================================================================

  static const double thumbnailSm = 40.0;
  static const double thumbnailMd = 56.0;
  static const double thumbnailLg = 72.0;

  static const double imagePreviewSm = 96.0;
  static const double imagePreviewMd = 128.0;

  // ===========================================================================
  // MISC
  // ===========================================================================

  /// Useful when a scrollable screen needs clearance above a bottom navbar.
  static const double bottomNavClearance = 96.0;

  /// Common small elevation-like vertical offset.
  static const double offsetSm = 4.0;

  static const double offsetMd = 8.0;
  static const double offsetLg = 12.0;
}
