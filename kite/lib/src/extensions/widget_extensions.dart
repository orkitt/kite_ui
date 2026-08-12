import 'package:flutter/material.dart';

/// Convenience helpers for composing Flutter widgets.
///
/// These helpers intentionally stay close to Flutter's native widgets so
/// layout behavior remains explicit and predictable.
extension WidgetExtensions on Widget {
  Widget padding(EdgeInsetsGeometry value) {
    return Padding(
      padding: value,
      child: this,
    );
  }

  Widget paddingAll(double value) {
    return Padding(
      padding: EdgeInsets.all(value),
      child: this,
    );
  }

  Widget paddingHorizontal(double value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: value),
      child: this,
    );
  }

  Widget paddingVertical(double value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: value),
      child: this,
    );
  }

  Widget paddingSymmetric({
    double horizontal = 0,
    double vertical = 0,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontal,
        vertical: vertical,
      ),
      child: this,
    );
  }

  Widget paddingOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: left,
        top: top,
        right: right,
        bottom: bottom,
      ),
      child: this,
    );
  }

  Widget centered({
    double? widthFactor,
    double? heightFactor,
  }) {
    return Center(
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      child: this,
    );
  }

  Widget align(
    AlignmentGeometry alignment, {
    double? widthFactor,
    double? heightFactor,
  }) {
    return Align(
      alignment: alignment,
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      child: this,
    );
  }

  Widget sized({
    double? width,
    double? height,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: this,
    );
  }

  Widget width(double value) {
    return SizedBox(
      width: value,
      child: this,
    );
  }

  Widget height(double value) {
    return SizedBox(
      height: value,
      child: this,
    );
  }

  Widget expanded({int flex = 1}) {
    return Expanded(
      flex: flex,
      child: this,
    );
  }

  Widget flexible({
    int flex = 1,
    FlexFit fit = FlexFit.loose,
  }) {
    return Flexible(
      flex: flex,
      fit: fit,
      child: this,
    );
  }

  Widget safeArea({
    bool left = true,
    bool top = true,
    bool right = true,
    bool bottom = true,
    EdgeInsets minimum = EdgeInsets.zero,
    bool maintainBottomViewPadding = false,
  }) {
    return SafeArea(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      minimum: minimum,
      maintainBottomViewPadding: maintainBottomViewPadding,
      child: this,
    );
  }

  Widget opacity(
    double value, {
    bool alwaysIncludeSemantics = false,
  }) {
    return Opacity(
      opacity: value.clamp(0.0, 1.0).toDouble(),
      alwaysIncludeSemantics: alwaysIncludeSemantics,
      child: this,
    );
  }

  Widget visible(
    bool value, {
    Widget replacement = const SizedBox.shrink(),
  }) {
    return Visibility(
      visible: value,
      replacement: replacement,
      child: this,
    );
  }

  Widget showIf(bool condition) {
    return condition ? this : const SizedBox.shrink();
  }

  Widget ignorePointer({bool ignoring = true}) {
    return IgnorePointer(
      ignoring: ignoring,
      child: this,
    );
  }

  Widget absorbPointer({bool absorbing = true}) {
    return AbsorbPointer(
      absorbing: absorbing,
      child: this,
    );
  }

  Widget onTap(
    VoidCallback? callback, {
    HitTestBehavior behavior = HitTestBehavior.opaque,
  }) {
    return GestureDetector(
      behavior: behavior,
      onTap: callback,
      child: this,
    );
  }

  Widget gesture({
    VoidCallback? onTap,
    VoidCallback? onDoubleTap,
    VoidCallback? onLongPress,
    GestureTapDownCallback? onTapDown,
    GestureTapUpCallback? onTapUp,
    HitTestBehavior behavior = HitTestBehavior.deferToChild,
  }) {
    return GestureDetector(
      behavior: behavior,
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      child: this,
    );
  }

  Widget inkWell({
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    BorderRadius? borderRadius,
    bool enableFeedback = true,
  }) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: borderRadius,
      enableFeedback: enableFeedback,
      child: this,
    );
  }

  Widget clipRadius(
    BorderRadiusGeometry borderRadius, {
    Clip clipBehavior = Clip.antiAlias,
  }) {
    return ClipRRect(
      borderRadius: borderRadius,
      clipBehavior: clipBehavior,
      child: this,
    );
  }

  Widget constrained({
    double minWidth = 0,
    double maxWidth = double.infinity,
    double minHeight = 0,
    double maxHeight = double.infinity,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: minWidth,
        maxWidth: maxWidth,
        minHeight: minHeight,
        maxHeight: maxHeight,
      ),
      child: this,
    );
  }

  Widget aspectRatio(double ratio) {
    return AspectRatio(
      aspectRatio: ratio,
      child: this,
    );
  }

  Widget tooltip(
    String message, {
    Duration? waitDuration,
  }) {
    return Tooltip(
      message: message,
      waitDuration: waitDuration,
      child: this,
    );
  }

  Widget hero(Object tag) {
    return Hero(
      tag: tag,
      child: this,
    );
  }

  Widget sliver() {
    return SliverToBoxAdapter(child: this);
  }

  Widget semantics({
    String? label,
    String? hint,
    bool? button,
    bool? enabled,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      button: button,
      enabled: enabled,
      child: this,
    );
  }

  /// Applies [wrapper] only when [condition] is true.
  Widget when(
    bool condition,
    Widget Function(Widget child) wrapper,
  ) {
    return condition ? wrapper(this) : this;
  }
}
