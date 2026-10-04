import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Composes widget lists into standard Flutter multi-child layouts.
///
/// These helpers preserve Flutter's layout behavior and constraints. They do
/// not insert spacing, choose theme values, or make a layout scrollable.
/// Do not mutate a list after passing it to a widget; create a new list instead.
///
/// ```dart
/// final layout = <Widget>[
///   const Text('Title'),
///   const Text('Details'),
/// ].column(crossAxisAlignment: CrossAxisAlignment.start);
/// ```
extension WidgetListExtensions on List<Widget> {
  /// Places these widgets in overlapping layers, painted in list order.
  ///
  /// Later children paint above earlier children. [fit] controls constraints
  /// for non-positioned children; positioned children use their own offsets.
  /// Directional [alignment] values require ambient [Directionality] or an
  /// explicit [textDirection].
  ///
  /// ```dart
  /// final layout = <Widget>[
  ///   background.positionedFill(),
  ///   content,
  /// ].stack();
  /// ```
  Stack stack({
    Key? key,
    AlignmentGeometry alignment = AlignmentDirectional.topStart,
    TextDirection? textDirection,
    StackFit fit = StackFit.loose,
    Clip clipBehavior = Clip.hardEdge,
  }) =>
      Stack(
        key: key,
        alignment: alignment,
        textDirection: textDirection,
        fit: fit,
        clipBehavior: clipBehavior,
        children: this,
      );

  /// Arranges these widgets vertically without scrolling.
  ///
  /// Expanded children require a bounded height. [textBaseline] must be set
  /// when using [CrossAxisAlignment.baseline]; Flutter only supports baseline
  /// alignment for a horizontal flex, so use [row] for that alignment.
  Column column({
    Key? key,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextBaseline? textBaseline,
  }) =>
      Column(
        key: key,
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: mainAxisSize,
        textDirection: textDirection,
        verticalDirection: verticalDirection,
        textBaseline: textBaseline,
        children: this,
      );

  /// Arranges these widgets horizontally without scrolling.
  ///
  /// Expanded children require a bounded width. Supply [textBaseline] when
  /// [crossAxisAlignment] is [CrossAxisAlignment.baseline].
  Row row({
    Key? key,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextBaseline? textBaseline,
  }) =>
      Row(
        key: key,
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: mainAxisSize,
        textDirection: textDirection,
        verticalDirection: verticalDirection,
        textBaseline: textBaseline,
        children: this,
      );

  /// Arranges these widgets in runs when available space is exhausted.
  ///
  /// [spacing] separates children within a run; [runSpacing] separates runs.
  /// Both default to zero and must be non-negative. A wrap is not scrollable.
  Wrap wrap({
    Key? key,
    Axis direction = Axis.horizontal,
    WrapAlignment alignment = WrapAlignment.start,
    double spacing = 0,
    WrapAlignment runAlignment = WrapAlignment.start,
    double runSpacing = 0,
    WrapCrossAlignment crossAxisAlignment = WrapCrossAlignment.start,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    Clip clipBehavior = Clip.none,
  }) =>
      Wrap(
        key: key,
        direction: direction,
        alignment: alignment,
        spacing: spacing,
        runAlignment: runAlignment,
        runSpacing: runSpacing,
        crossAxisAlignment: crossAxisAlignment,
        textDirection: textDirection,
        verticalDirection: verticalDirection,
        clipBehavior: clipBehavior,
        children: this,
      );
}

/// Adds explicit layout and decoration wrappers to a widget.
///
/// Calls wrap from left to right: `child.padding(insets).expanded()` produces
/// an [Expanded] containing a [Padding] containing `child`.
/// Flutter parent-data and constraint rules still apply.
extension WidgetLayoutExtensions on Widget {
  /// Insets this widget using caller-provided, non-negative padding.
  ///
  /// Directional insets resolve using ambient [Directionality].
  Padding padding(EdgeInsetsGeometry insets, {Key? key}) =>
      Padding(key: key, padding: insets, child: this);

  /// Centers this widget within the available space.
  ///
  /// Non-null size factors size the wrapper relative to the child and must be
  /// non-negative. Parent constraints can still limit the resulting size.
  Center center({Key? key, double? widthFactor, double? heightFactor}) =>
      Center(
        key: key,
        widthFactor: widthFactor,
        heightFactor: heightFactor,
        child: this,
      );

  /// Aligns this widget within the available space.
  ///
  /// Directional [alignment] values require ambient [Directionality].
  /// Non-null size factors must be non-negative.
  Align align(
    AlignmentGeometry alignment, {
    Key? key,
    double? widthFactor,
    double? heightFactor,
  }) =>
      Align(
        key: key,
        alignment: alignment,
        widthFactor: widthFactor,
        heightFactor: heightFactor,
        child: this,
      );

  /// Fills a share of remaining space in a [Row], [Column], or [Flex].
  ///
  /// [flex] must be non-negative; zero uses non-flex layout. A positive flex
  /// requires the parent to provide bounded main-axis space.
  /// Keep this wrapper outside render-object wrappers such as [Padding]:
  /// use `child.padding(insets).expanded()` inside the flex's children.
  Expanded expanded({Key? key, int flex = 1}) =>
      Expanded(key: key, flex: flex, child: this);

  /// Allocates flex space with either loose or tight child constraints.
  ///
  /// [flex] must be non-negative; zero uses the child's non-flex layout.
  /// This wrapper belongs inside a [Row], [Column], or [Flex], without
  /// intervening render-object widgets. Unbounded main-axis constraints may
  /// require a shrink-wrapped flex with [FlexFit.loose].
  Flexible flexible({Key? key, int flex = 1, FlexFit fit = FlexFit.loose}) =>
      Flexible(key: key, flex: flex, fit: fit, child: this);

  /// Requests a width and/or height, subject to the parent's constraints.
  ///
  /// Null dimensions leave that axis unconstrained by this wrapper. Explicit
  /// dimensions must be non-negative; infinity requires bounded parent space.
  SizedBox sized({Key? key, double? width, double? height}) =>
      SizedBox(key: key, width: width, height: height, child: this);

  /// Positions this widget relative to a [Stack]'s edges.
  ///
  /// Specify at most two of [left], [right], and [width], and at most two of
  /// [top], [bottom], and [height]. Opposing edges determine the child's size.
  /// Positioned children do not determine the stack's size.
  ///
  /// Keep this wrapper outside render-object wrappers:
  /// `child.padding(insets).positioned(bottom: 0)` belongs in stack children.
  Positioned positioned({
    Key? key,
    double? left,
    double? top,
    double? right,
    double? bottom,
    double? width,
    double? height,
  }) =>
      Positioned(
        key: key,
        left: left,
        top: top,
        right: right,
        bottom: bottom,
        width: width,
        height: height,
        child: this,
      );

  /// Stretches this widget between a [Stack]'s edges.
  ///
  /// Offsets default to zero. Null offsets release that edge's constraint.
  /// The stack needs a size from its parent or non-positioned children.
  /// The same parent-data rules as [positioned] apply.
  Positioned positionedFill({
    Key? key,
    double? left = 0,
    double? top = 0,
    double? right = 0,
    double? bottom = 0,
  }) =>
      Positioned.fill(
        key: key,
        left: left,
        top: top,
        right: right,
        bottom: bottom,
        child: this,
      );

  /// Paints a caller-provided box decoration behind or in front of this widget.
  ///
  /// This wrapper adds no padding and does not clip the child. Resolve colors
  /// from your application's theme before creating [decoration].
  DecoratedBox decorated(
    BoxDecoration decoration, {
    Key? key,
    DecorationPosition position = DecorationPosition.background,
  }) =>
      DecoratedBox(
        key: key,
        decoration: decoration,
        position: position,
        child: this,
      );

  /// Clips this widget to a rounded rectangle using the supplied radius.
  ///
  /// Directional radii resolve using ambient [Directionality]. Clipping does
  /// not add a border, decoration, or layout constraints.
  ClipRRect clipRounded(
    BorderRadiusGeometry borderRadius, {
    Key? key,
    Clip clipBehavior = Clip.antiAlias,
  }) =>
      ClipRRect(
        key: key,
        borderRadius: borderRadius,
        clipBehavior: clipBehavior,
        child: this,
      );
}

/// Convenience helpers for composing Flutter widgets.
///
/// These helpers intentionally stay close to Flutter's native widgets so
/// layout behavior remains explicit and predictable.
extension WidgetExtensions on Widget {
  Widget padding(EdgeInsetsGeometry value) {
    return Padding(padding: value, child: this);
  }

  Widget paddingAll(double value) {
    return Padding(padding: EdgeInsets.all(value), child: this);
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

  Widget paddingSymmetric({double horizontal = 0, double vertical = 0}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
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

  Widget opacity(double value, {bool alwaysIncludeSemantics = false}) {
    return Opacity(
      opacity: value.clamp(0.0, 1.0).toDouble(),
      alwaysIncludeSemantics: alwaysIncludeSemantics,
      child: this,
    );
  }

  Widget visible(bool value, {Widget replacement = const SizedBox.shrink()}) {
    return Visibility(visible: value, replacement: replacement, child: this);
  }

  Widget showIf(bool condition) {
    return condition ? this : const SizedBox.shrink();
  }

  Widget ignorePointer({bool ignoring = true}) {
    return IgnorePointer(ignoring: ignoring, child: this);
  }

  Widget absorbPointer({bool absorbing = true}) {
    return AbsorbPointer(absorbing: absorbing, child: this);
  }

  Widget onTap(
    VoidCallback? callback, {
    HitTestBehavior behavior = HitTestBehavior.opaque,
  }) {
    return GestureDetector(behavior: behavior, onTap: callback, child: this);
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
    return AspectRatio(aspectRatio: ratio, child: this);
  }

  Widget tooltip(String message, {Duration? waitDuration}) {
    return Tooltip(message: message, waitDuration: waitDuration, child: this);
  }

  Widget hero(Object tag) {
    return Hero(tag: tag, child: this);
  }

  Widget sliver() {
    return SliverToBoxAdapter(child: this);
  }

  Widget semantics({String? label, String? hint, bool? button, bool? enabled}) {
    return Semantics(
      label: label,
      hint: hint,
      button: button,
      enabled: enabled,
      child: this,
    );
  }

  /// Applies [wrapper] only when [condition] is true.
  Widget when(bool condition, Widget Function(Widget child) wrapper) {
    return condition ? wrapper(this) : this;
  }
}
