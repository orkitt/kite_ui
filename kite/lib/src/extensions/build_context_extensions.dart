import 'package:flutter/material.dart';

/// Convenient access to commonly used inherited Flutter properties.
extension BuildContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => theme.colorScheme;

  TextTheme get textTheme => theme.textTheme;

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  Size get screenSize => mediaQuery.size;

  double get screenWidth => screenSize.width;

  double get screenHeight => screenSize.height;

  EdgeInsets get viewPadding => mediaQuery.viewPadding;

  EdgeInsets get viewInsets => mediaQuery.viewInsets;

  EdgeInsets get screenPadding => mediaQuery.padding;

  double get keyboardHeight => viewInsets.bottom;

  bool get isKeyboardVisible => keyboardHeight > 0;

  Orientation get orientation => mediaQuery.orientation;

  bool get isPortrait => orientation == Orientation.portrait;

  bool get isLandscape => orientation == Orientation.landscape;

  Brightness get brightness => theme.brightness;

  bool get isDarkMode => brightness == Brightness.dark;

  bool get isLightMode => brightness == Brightness.light;

  TextDirection get textDirection => Directionality.of(this);

  bool get isRtl => textDirection == TextDirection.rtl;

  bool get isLtr => textDirection == TextDirection.ltr;

  NavigatorState get navigator => Navigator.of(this);

  FocusScopeNode get focusScope => FocusScope.of(this);

  ScaffoldMessengerState get scaffoldMessenger =>
      ScaffoldMessenger.of(this);

  ModalRoute<dynamic>? get modalRoute => ModalRoute.of(this);

  /// Whether the current [BuildContext] is still mounted.
  bool get isMounted => mounted;

  /// Removes focus from the currently focused input.
  void unfocus() {
    focusScope.unfocus();
  }

  /// Returns whether the current route can be popped.
  bool get canPop => navigator.canPop();

  /// Pops the current route.
  void pop<T extends Object?>([T? result]) {
    navigator.pop(result);
  }

  /// Displays a Material snackbar after clearing the current one.
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

  /// Compact window breakpoint.
  bool get isCompact => screenWidth < 600;

  /// Medium window breakpoint.
  bool get isMedium => screenWidth >= 600 && screenWidth < 1024;

  /// Expanded window breakpoint.
  bool get isExpanded => screenWidth >= 1024;
}
