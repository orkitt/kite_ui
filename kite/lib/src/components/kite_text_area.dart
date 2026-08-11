// Kite UI Components
// Copyright (c) 2026 Kite UI Contributors.
// Licensed under the MIT License. Keep this notice in substantial copies.
// Learn more: https://kite.orkitt.dev
import 'package:flutter/material.dart';

import '../design/dimension.dart';
import '../design/kolors.dart';
import '../design/shapes.dart';
import '../design/typography.dart';

class KiteTextArea extends StatefulWidget {
  const KiteTextArea({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.helper,
    this.errorText,
    this.minLines = 4,
    this.maxLines = 8,
    this.maxLength,
    this.enabled = true,
    this.onChanged,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? helper;
  final String? errorText;
  final int minLines;
  final int maxLines;
  final int? maxLength;
  final bool enabled;
  final ValueChanged<String>? onChanged;

  @override
  State<KiteTextArea> createState() => _KiteTextAreaState();
}

class _KiteTextAreaState extends State<KiteTextArea> {
  late final FocusNode _focusNode;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(_handleFocus);
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_handleFocus)
      ..dispose();
    super.dispose();
  }

  void _handleFocus() => setState(() => _focused = _focusNode.hasFocus);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.typography;
    final hasError = widget.errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!, style: type.labelSmall),
          Dimensions.vBox8,
        ],
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: Dimensions.p12,
          decoration: ShapeDecoration(
            color: widget.enabled ? colors.inputFill : colors.muted,
            shape: Shapes.rounded12.copyWith(
              side: BorderSide(
                color: hasError
                    ? colors.error
                    : _focused
                    ? colors.primary
                    : colors.border,
                width: hasError || _focused ? 1.5 : 1,
              ),
            ),
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            minLines: widget.minLines,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            enabled: widget.enabled,
            onChanged: widget.onChanged,
            style: type.body,
            cursorColor: colors.primary,
            decoration: InputDecoration(
              isDense: true,
              hintText: widget.hint,
              hintStyle: type.body.copyWith(color: colors.textDisabled),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              counterStyle: type.caption,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
        if (hasError) ...[
          Dimensions.vBox8,
          Text(
            widget.errorText!,
            style: type.caption.copyWith(color: colors.error),
          ),
        ] else if (widget.helper != null) ...[
          Dimensions.vBox8,
          Text(widget.helper!, style: type.caption),
        ],
      ],
    );
  }
}
