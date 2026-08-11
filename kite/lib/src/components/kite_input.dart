// Kite UI Components
// Copyright (c) 2026 Kite UI Contributors.
// Licensed under the MIT License. Keep this notice in substantial copies.
// Learn more: https://kite.orkitt.dev
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../design/dimension.dart';
import '../design/kolors.dart';
import '../design/shapes.dart';
import '../design/typography.dart';

enum KiteInputType { text, password, phone, email, number }

class KiteInput extends StatefulWidget {
  const KiteInput({
    super.key,
    this.controller,
    this.initialValue,
    this.label,
    this.hint,
    this.helper,
    this.errorText,
    this.prefixIcon,
    this.suffix,
    this.type = KiteInputType.text,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.textInputAction,
    this.focusNode,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final String? label;
  final String? hint;
  final String? helper;
  final String? errorText;
  final Widget? prefixIcon;
  final Widget? suffix;
  final KiteInputType type;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;

  @override
  State<KiteInput> createState() => _KiteInputState();
}

class _KiteInputState extends State<KiteInput> {
  late final FocusNode _internalFocusNode;
  bool _obscure = true;
  bool _focused = false;

  FocusNode get _focusNode => widget.focusNode ?? _internalFocusNode;

  @override
  void initState() {
    super.initState();
    _internalFocusNode = FocusNode();
    _focusNode.addListener(_handleFocus);
  }

  @override
  void didUpdateWidget(covariant KiteInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      (oldWidget.focusNode ?? _internalFocusNode).removeListener(_handleFocus);
      _focusNode.addListener(_handleFocus);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocus);
    _internalFocusNode.dispose();
    super.dispose();
  }

  void _handleFocus() {
    if (mounted) setState(() => _focused = _focusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.typography;
    final password = widget.type == KiteInputType.password;
    final hasError = widget.errorText != null;
    final borderColor = hasError
        ? colors.error
        : _focused
        ? colors.primary
        : colors.border;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: type.labelSmall.copyWith(
              color: hasError ? colors.error : colors.textPrimary,
            ),
          ),
          Dimensions.vBox8,
        ],
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          constraints: const BoxConstraints(
            minHeight: Dimensions.buttonHeightLg,
          ),
          padding: Dimensions.px12,
          decoration: ShapeDecoration(
            color: widget.enabled ? colors.inputFill : colors.muted,
            shape: Shapes.rounded12.copyWith(
              side: BorderSide(
                color: widget.enabled ? borderColor : colors.borderSoft,
                width: _focused || hasError ? 1.5 : 1,
              ),
            ),
            shadows: _focused && !hasError
                ? [
                    BoxShadow(
                      color: colors.primary.withValues(alpha: .08),
                      blurRadius: Dimensions.s8,
                      spreadRadius: Dimensions.s2,
                    ),
                  ]
                : const [],
          ),
          child: Row(
            children: [
              if (widget.prefixIcon != null) ...[
                IconTheme(
                  data: IconThemeData(
                    color: _focused ? colors.primary : colors.icon,
                    size: Dimensions.iconSm,
                  ),
                  child: widget.prefixIcon!,
                ),
                Dimensions.hBox12,
              ],
              Expanded(
                child: TextFormField(
                  controller: widget.controller,
                  initialValue: widget.controller == null
                      ? widget.initialValue
                      : null,
                  focusNode: _focusNode,
                  enabled: widget.enabled,
                  readOnly: widget.readOnly,
                  autofocus: widget.autofocus,
                  obscureText: password && _obscure,
                  keyboardType: _keyboardType,
                  autofillHints: _autofillHints,
                  inputFormatters: _formatters,
                  textInputAction: widget.textInputAction,
                  onChanged: widget.onChanged,
                  onFieldSubmitted: widget.onSubmitted,
                  validator: widget.validator,
                  style: type.body.copyWith(
                    color: widget.enabled
                        ? colors.textPrimary
                        : colors.textDisabled,
                  ),
                  cursorColor: colors.primary,
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    hintText: widget.hint,
                    hintStyle: type.body.copyWith(color: colors.textDisabled),
                    errorStyle: const TextStyle(fontSize: 0, height: 0),
                  ),
                ),
              ),
              if (password) ...[
                Dimensions.hBox8,
                _FieldAction(
                  icon: _obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  onTap: () => setState(() => _obscure = !_obscure),
                ),
              ] else if (widget.suffix != null) ...[
                Dimensions.hBox8,
                IconTheme(
                  data: IconThemeData(
                    color: colors.icon,
                    size: Dimensions.iconSm,
                  ),
                  child: widget.suffix!,
                ),
              ],
            ],
          ),
        ),
        if (widget.errorText != null) ...[
          Dimensions.vBox8,
          Text(
            widget.errorText!,
            style: type.caption.copyWith(color: colors.error),
          ),
        ] else if (widget.helper != null) ...[
          Dimensions.vBox8,
          Text(
            widget.helper!,
            style: type.caption.copyWith(color: colors.textSecondary),
          ),
        ],
      ],
    );
  }

  TextInputType get _keyboardType => switch (widget.type) {
    KiteInputType.phone => TextInputType.phone,
    KiteInputType.email => TextInputType.emailAddress,
    KiteInputType.number => const TextInputType.numberWithOptions(
      decimal: true,
    ),
    _ => TextInputType.text,
  };

  Iterable<String>? get _autofillHints => switch (widget.type) {
    KiteInputType.password => const [AutofillHints.password],
    KiteInputType.phone => const [AutofillHints.telephoneNumber],
    KiteInputType.email => const [AutofillHints.email],
    _ => null,
  };

  List<TextInputFormatter>? get _formatters => switch (widget.type) {
    KiteInputType.phone => [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9+\- ()]')),
    ],
    KiteInputType.number => [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
    ],
    _ => null,
  };
}

class _FieldAction extends StatelessWidget {
  const _FieldAction({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox.square(
        dimension: Dimensions.s32,
        child: Icon(icon, size: Dimensions.iconSm, color: context.colors.icon),
      ),
    );
  }
}

class KiteOtpInput extends StatefulWidget {
  const KiteOtpInput({
    required this.onChanged,
    super.key,
    this.length = 6,
    this.onCompleted,
    this.autofocus = true,
  });

  final int length;
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onCompleted;
  final bool autofocus;

  @override
  State<KiteOtpInput> createState() => _KiteOtpInputState();
}

class _KiteOtpInputState extends State<KiteOtpInput> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
    for (final node in _focusNodes) {
      node.addListener(_rebuild);
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node
        ..removeListener(_rebuild)
        ..dispose();
    }
    super.dispose();
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  void _emit() {
    final value = _controllers.map((controller) => controller.text).join();
    widget.onChanged(value);
    if (value.length == widget.length) widget.onCompleted?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: List.generate(widget.length, (index) {
        final focused = _focusNodes[index].hasFocus;
        final filled = _controllers[index].text.isNotEmpty;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index == widget.length - 1
                  ? Dimensions.zero
                  : Dimensions.s8,
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 140),
              height: Dimensions.buttonHeightLg,
              alignment: Alignment.center,
              decoration: ShapeDecoration(
                color: focused ? colors.card : colors.inputFill,
                shape: Shapes.rounded12.copyWith(
                  side: BorderSide(
                    color: focused
                        ? colors.primary
                        : filled
                        ? colors.borderStrong
                        : colors.border,
                    width: focused ? 1.5 : 1,
                  ),
                ),
              ),
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                autofocus: widget.autofocus && index == 0,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                textInputAction: index == widget.length - 1
                    ? TextInputAction.done
                    : TextInputAction.next,
                maxLength: 1,
                style: context.typography.title,
                cursorColor: colors.primary,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (value) {
                  if (value.isNotEmpty && index < widget.length - 1) {
                    _focusNodes[index + 1].requestFocus();
                  } else if (value.isEmpty && index > 0) {
                    _focusNodes[index - 1].requestFocus();
                  }
                  setState(() {});
                  _emit();
                },
              ),
            ),
          ),
        );
      }),
    );
  }
}
