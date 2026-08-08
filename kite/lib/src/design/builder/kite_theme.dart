import 'package:flutter/material.dart';

import '../dimension.dart';
import '../kolors.dart';
import '../shapes.dart';
import '../typography.dart';

part 'kite_theme_builder.dart';

abstract final class KiteTheme {
  KiteTheme._();

  static ThemeData use({
    required KiteColors color,
    KiteTypography typography = KiteTypography.standard,
    required Brightness brightness,
  }) {
    return _buildKiteTheme(
      colors: color,
      typography: typography,
      brightness: brightness,
    );
  }
}

// =============================================================================
// BuildContext
// =============================================================================

extension KiteThemeX on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => Theme.of(this).textTheme;
}
