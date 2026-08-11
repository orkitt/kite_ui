import 'package:flutter/material.dart';

import 'kolors.dart';

/// Built with Kite 🪁
/// Flutter foundations, architecture, and developer tooling.
/// Learn more: https://kite.orkitt.dev
@immutable
class KiteTypography extends ThemeExtension<KiteTypography> {
  const KiteTypography({
    required this.display,
    required this.heading,
    required this.section,
    required this.title,
    required this.lead,
    required this.body,
    required this.paragraph,
    required this.label,
    required this.labelSmall,
    required this.caption,
  });

  // ===========================================================================
  // Display
  // ===========================================================================

  /// Hero, onboarding, marketing, and large feature statements.
  final TextStyle display;

  // ===========================================================================
  // Headings
  // ===========================================================================

  /// Primary page or screen heading.
  final TextStyle heading;

  /// Section, sheet, modal, and dialog heading.
  final TextStyle section;

  /// Card, list, panel, and component title.
  final TextStyle title;

  // ===========================================================================
  // Content
  // ===========================================================================

  /// Prominent descriptive content below headings.
  final TextStyle lead;

  /// Default readable application content.
  final TextStyle body;

  /// Compact supporting and secondary content.
  final TextStyle paragraph;

  // ===========================================================================
  // Controls
  // ===========================================================================

  /// Buttons, form labels, navigation, and controls.
  final TextStyle label;

  /// Tabs, chips, badges, and compact controls.
  final TextStyle labelSmall;

  // ===========================================================================
  // Supporting
  // ===========================================================================

  /// Metadata, timestamps, helper text, and subtle details.
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
    heading: TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.w700,
      height: 1.15,
      letterSpacing: -0.70,
    ),
    section: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      height: 1.25,
      letterSpacing: -0.30,
    ),
    title: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.30,
      letterSpacing: -0.10,
    ),
    lead: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.50,
      letterSpacing: -0.05,
    ),
    body: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, height: 1.45),
    paragraph: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      height: 1.40,
    ),
    label: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 1.20),
    labelSmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      height: 1.20,
      letterSpacing: 0.10,
    ),
    caption: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      height: 1.30,
      letterSpacing: 0.15,
    ),
  );

  // ===========================================================================
  // Generated Variants
  // ===========================================================================

  /// Compact page heading.
  TextStyle get headingSmall =>
      heading.copyWith(fontSize: 24, height: 1.20, letterSpacing: -0.45);

  /// Compact section heading.
  TextStyle get sectionSmall => section.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.30,
    letterSpacing: -0.15,
  );

  /// Supporting title or subtitle.
  TextStyle get subtitle => paragraph.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.40,
  );

  /// Strong readable content.
  TextStyle get bodyStrong => body.copyWith(fontWeight: FontWeight.w600);

  /// Strong supporting content.
  TextStyle get paragraphStrong =>
      paragraph.copyWith(fontWeight: FontWeight.w600);

  /// Larger label for prominent controls.
  TextStyle get labelLarge => label.copyWith(fontSize: 15, height: 1.20);

  /// Strong metadata or helper text.
  TextStyle get captionStrong => caption.copyWith(fontWeight: FontWeight.w600);

  // ===========================================================================
  // Color Resolution
  // ===========================================================================

  /// Applies semantic Kite colors while preserving typography metrics.
  KiteTypography resolve(KiteColors colors) {
    return copyWith(
      display: display.copyWith(color: colors.textPrimary),
      heading: heading.copyWith(color: colors.textPrimary),
      section: section.copyWith(color: colors.textPrimary),
      title: title.copyWith(color: colors.textPrimary),
      lead: lead.copyWith(color: colors.textSecondary),
      body: body.copyWith(color: colors.textPrimary),
      paragraph: paragraph.copyWith(color: colors.textSecondary),
      label: label.copyWith(color: colors.textPrimary),
      labelSmall: labelSmall.copyWith(color: colors.textSecondary),
      caption: caption.copyWith(color: colors.textSecondary),
    );
  }

  // ===========================================================================
  // Material Adapter
  // ===========================================================================

  /// Maps Kite typography into Flutter's Material [TextTheme].
  TextTheme toTextTheme() {
    return TextTheme(
      // Display
      displayLarge: display,
      displayMedium: heading,
      displaySmall: section,

      // Headlines
      headlineLarge: heading,
      headlineMedium: section,
      headlineSmall: title,

      // Titles
      titleLarge: section,
      titleMedium: title,
      titleSmall: label,

      // Body
      bodyLarge: lead,
      bodyMedium: body,
      bodySmall: paragraph,

      // Labels
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
    TextStyle? heading,
    TextStyle? section,
    TextStyle? title,
    TextStyle? lead,
    TextStyle? body,
    TextStyle? paragraph,
    TextStyle? label,
    TextStyle? labelSmall,
    TextStyle? caption,
  }) {
    return KiteTypography(
      display: display ?? this.display,
      heading: heading ?? this.heading,
      section: section ?? this.section,
      title: title ?? this.title,
      lead: lead ?? this.lead,
      body: body ?? this.body,
      paragraph: paragraph ?? this.paragraph,
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
      heading: TextStyle.lerp(heading, other.heading, t)!,
      section: TextStyle.lerp(section, other.section, t)!,
      title: TextStyle.lerp(title, other.title, t)!,
      lead: TextStyle.lerp(lead, other.lead, t)!,
      body: TextStyle.lerp(body, other.body, t)!,
      paragraph: TextStyle.lerp(paragraph, other.paragraph, t)!,
      label: TextStyle.lerp(label, other.label, t)!,
      labelSmall: TextStyle.lerp(labelSmall, other.labelSmall, t)!,
      caption: TextStyle.lerp(caption, other.caption, t)!,
    );
  }
}

// =============================================================================
// BuildContext
// =============================================================================

extension KiteTypographyX on BuildContext {
  KiteTypography get typography {
    final typography = Theme.of(this).extension<KiteTypography>();
    if (typography != null) return typography;

    throw FlutterError.fromParts([
      ErrorSummary(
        'KiteTypography is not registered in ThemeData.extensions.',
      ),
      ErrorDescription(
        'A widget requested context.typography, but the active ThemeData does '
        'not contain a KiteTypography extension.',
      ),
      ErrorHint(
        'Build the app theme with KiteTheme.use(...) or register '
        'KiteTypography in ThemeData.extensions.',
      ),
    ]);
  }
}
