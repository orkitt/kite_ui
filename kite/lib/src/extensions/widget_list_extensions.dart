import 'package:flutter/widgets.dart';

/// Helpers for adding consistent spacing between sibling widgets.
extension WidgetListExtensions on List<Widget> {
  List<Widget> separatedBy(Widget separator) {
    if (length <= 1) return this;

    return [
      for (var index = 0; index < length; index++) ...[
        if (index > 0) separator,
        this[index],
      ],
    ];
  }

  List<Widget> spaced(double spacing) {
    return separatedBy(SizedBox(height: spacing));
  }

  List<Widget> spacedHorizontal(double spacing) {
    return separatedBy(SizedBox(width: spacing));
  }
}
