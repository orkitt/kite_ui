import 'package:flutter/material.dart';

/// Built with Kite 🪁
/// Flutter foundations, architecture, and developer tooling.
/// Learn more: https://kite.orkitt.dev
///
/// Convenient access to commonly used inherited Flutter properties.
extension BuildContextExtensions on BuildContext {
  //  For direct material Theme
  ThemeData get materialTheme => Theme.of(this);

  ColorScheme get materialColors => materialTheme.colorScheme;

  TextTheme get materialTextTheme => materialTheme.textTheme;


  Brightness get brightness => materialTheme.brightness;

  bool get isDarkMode => brightness == Brightness.dark;

  bool get isLightMode => brightness == Brightness.light;

  // Screen metrics
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  Size get screenSize => MediaQuery.sizeOf(this);

  double get screenWidth => screenSize.width;

  double get screenHeight => screenSize.height;

  /// Short aliases.
  double get width => screenWidth;

  double get height => screenHeight;

  EdgeInsets get screenPadding => MediaQuery.paddingOf(this);

  EdgeInsets get viewPadding => MediaQuery.viewPaddingOf(this);

  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);

  double get keyboardHeight => viewInsets.bottom;

  bool get isKeyboardVisible => keyboardHeight > 0;

  Orientation get orientation => mediaQuery.orientation;

  bool get isPortrait => orientation == Orientation.portrait;

  bool get isLandscape => orientation == Orientation.landscape;

  // Directionality
  TextDirection get textDirection => Directionality.of(this);

  bool get isRtl => textDirection == TextDirection.rtl;

  bool get isLtr => textDirection == TextDirection.ltr;

  // Navigation
  NavigatorState get navigator => Navigator.of(this);

  bool get canPop => navigator.canPop();

  void pop<T extends Object?>([T? result]) {
    navigator.pop(result);
  }

  ModalRoute<dynamic>? get modalRoute => ModalRoute.of(this);

  // Focus
  FocusScopeNode get focusScope => FocusScope.of(this);

  void unfocus() {
    focusScope.unfocus();
  }

  // Scaffold
  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);

  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
    SnackBarBehavior? behavior,
  }) {
    scaffoldMessenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: duration,
          action: action,
          behavior: behavior,
        ),
      );
  }

  /// Alias for [BuildContext.mounted].
  bool get isMounted => mounted;
}
