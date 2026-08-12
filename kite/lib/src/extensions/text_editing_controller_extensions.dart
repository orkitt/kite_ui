import 'package:flutter/widgets.dart';

extension TextEditingControllerExtensions on TextEditingController {
  bool get isBlank => text.trim().isEmpty;

  bool get isNotBlank => text.trim().isNotEmpty;

  String get trimmedText => text.trim();

  void clearAndUnfocus(FocusNode? focusNode) {
    clear();
    focusNode?.unfocus();
  }

  void setText(
    String value, {
    bool moveCursorToEnd = true,
  }) {
    text = value;

    if (moveCursorToEnd) {
      selection = TextSelection.collapsed(offset: text.length);
    }
  }
}
