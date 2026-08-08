import 'package:flutter/material.dart';

import 'kolors.dart';

@immutable
class KiteTypography extends ThemeExtension<KiteTypography> {
  const KiteTypography({
    required this.display,
    required this.h1,
    required this.h2,
    required this.h3,
    required this.title,
    required this.bodyLarge,
    required this.body,
    required this.bodySmall,
    required this.label,
    required this.labelSmall,
    required this.caption,
  });

  // ---------------------------------------------------------------------------
  // Display
  // ---------------------------------------------------------------------------

  /// Hero text, landing pages, large marketing headings.
  final TextStyle display;

  // ---------------------------------------------------------------------------
  // Headings
  // ---------------------------------------------------------------------------

  /// Primary page heading.
  final TextStyle h1;

  /// Section heading.
  final TextStyle h2;

  /// Small section / dialog heading.
  final TextStyle h3;

  // ---------------------------------------------------------------------------
  // Title
  // ---------------------------------------------------------------------------

  /// Card titles, list titles, input-related titles.
  final TextStyle title;

  // ---------------------------------------------------------------------------
  // Body
  // ---------------------------------------------------------------------------

  /// Emphasized or spacious body content.
  final TextStyle bodyLarge;

  /// Default application body text.
  final TextStyle body;

  /// Secondary and compact body text.
  final TextStyle bodySmall;

  // ---------------------------------------------------------------------------
  // Labels
  // ---------------------------------------------------------------------------

  /// Buttons, controls, navigation labels.
  final TextStyle label;

  /// Chips, tabs, compact controls.
  final TextStyle labelSmall;

  // ---------------------------------------------------------------------------
  // Supporting
  // ---------------------------------------------------------------------------

  /// Helper text, metadata, timestamps.
  final TextStyle caption;

  // ===========================================================================
  // Standard
  // ===========================================================================

  static const standard = KiteTypography(
    display: TextStyle(
      fontSize: 40,
      fontWeight: FontWeight.w700,
      height: 1.10,
      letterSpacing: -1.0,
    ),
    h1: TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.w700,
      height: 1.15,
      letterSpacing: -0.7,
    ),
    h2: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      height: 1.20,
      letterSpacing: -0.45,
    ),
    h3: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      height: 1.25,
      letterSpacing: -0.25,
    ),
    title: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.30,
      letterSpacing: -0.1,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.50,
      letterSpacing: -0.05,
    ),
    body: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, height: 1.45),
    bodySmall: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      height: 1.40,
    ),
    label: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 1.20),
    labelSmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      height: 1.20,
      letterSpacing: 0.1,
    ),
    caption: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      height: 1.30,
      letterSpacing: 0.15,
    ),
  );

  // ===========================================================================
  // Color Resolution
  // ===========================================================================

  /// Applies the active Kite color palette to typography.
  ///
  /// Typography controls font metrics.
  /// KiteColors remains the source of truth for content colors.
  KiteTypography resolve(KiteColors colors) {
    return copyWith(
      display: display.copyWith(color: colors.textPrimary),
      h1: h1.copyWith(color: colors.textPrimary),
      h2: h2.copyWith(color: colors.textPrimary),
      h3: h3.copyWith(color: colors.textPrimary),
      title: title.copyWith(color: colors.textPrimary),
      bodyLarge: bodyLarge.copyWith(color: colors.textPrimary),
      body: body.copyWith(color: colors.textPrimary),
      bodySmall: bodySmall.copyWith(color: colors.textSecondary),
      label: label.copyWith(color: colors.textPrimary),
      labelSmall: labelSmall.copyWith(color: colors.textSecondary),
      caption: caption.copyWith(color: colors.textSecondary),
    );
  }

  // ===========================================================================
  // Material TextTheme Adapter
  // ===========================================================================

  TextTheme toTextTheme() {
    return TextTheme(
      // Display
      displayLarge: display,
      displayMedium: h1,
      displaySmall: h2,

      // Headline
      headlineLarge: h1,
      headlineMedium: h2,
      headlineSmall: h3,

      // Title
      titleLarge: h3,
      titleMedium: title,
      titleSmall: label,

      // Body
      bodyLarge: bodyLarge,
      bodyMedium: body,
      bodySmall: bodySmall,

      // Label
      labelLarge: label,
      labelMedium: labelSmall,
      labelSmall: caption,
    );
  }

  // ===========================================================================
  // ThemeExtension
  // ===========================================================================

  @override
  KiteTypography copyWith({
    TextStyle? display,
    TextStyle? h1,
    TextStyle? h2,
    TextStyle? h3,
    TextStyle? title,
    TextStyle? bodyLarge,
    TextStyle? body,
    TextStyle? bodySmall,
    TextStyle? label,
    TextStyle? labelSmall,
    TextStyle? caption,
  }) {
    return KiteTypography(
      display: display ?? this.display,
      h1: h1 ?? this.h1,
      h2: h2 ?? this.h2,
      h3: h3 ?? this.h3,
      title: title ?? this.title,
      bodyLarge: bodyLarge ?? this.bodyLarge,
      body: body ?? this.body,
      bodySmall: bodySmall ?? this.bodySmall,
      label: label ?? this.label,
      labelSmall: labelSmall ?? this.labelSmall,
      caption: caption ?? this.caption,
    );
  }

  @override
  KiteTypography lerp(covariant KiteTypography? other, double t) {
    if (other == null) {
      return this;
    }

    return KiteTypography(
      display: TextStyle.lerp(display, other.display, t)!,
      h1: TextStyle.lerp(h1, other.h1, t)!,
      h2: TextStyle.lerp(h2, other.h2, t)!,
      h3: TextStyle.lerp(h3, other.h3, t)!,
      title: TextStyle.lerp(title, other.title, t)!,
      bodyLarge: TextStyle.lerp(bodyLarge, other.bodyLarge, t)!,
      body: TextStyle.lerp(body, other.body, t)!,
      bodySmall: TextStyle.lerp(bodySmall, other.bodySmall, t)!,
      label: TextStyle.lerp(label, other.label, t)!,
      labelSmall: TextStyle.lerp(labelSmall, other.labelSmall, t)!,
      caption: TextStyle.lerp(caption, other.caption, t)!,
    );
  }
}

// =============================================================================
// BuildContext
// =============================================================================

extension AppTypographyX on BuildContext {
  KiteTypography get typography {
    final typography = Theme.of(this).extension<KiteTypography>();

    assert(
      typography != null,
      'AppTypography is not registered in ThemeData.extensions.',
    );

    return typography!;
  }
}
