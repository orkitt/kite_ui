import 'package:flutter/material.dart';
import '../design/kolors.dart';

/// Built with Kite 🪁
/// Flutter foundations, architecture, and developer tooling.
/// Learn more: https://kite.orkitt.dev
extension BuildContextX on BuildContext {
  // Screen Metrics & MediaQuery
  Size get screenSize => MediaQuery.sizeOf(this);
  double get width => screenSize.width;
  double get height => screenSize.height;
  EdgeInsets get padding => MediaQuery.paddingOf(this);
  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);

  // Platform & Breakpoint helpers
  bool get isLandscape =>
      MediaQuery.orientationOf(this) == Orientation.landscape;
  bool get isKeyboardOpen => viewInsets.bottom > 0;

  // Quick Actions
  void unfocus() => FocusScope.of(this).unfocus();
  void showSnackBar(
    String message, {
    bool isError = false,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? colors.error : colors.textPrimary,
          duration: duration,
        ),
      );
  }
}
