import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../dimension.dart';
import 'responsive_kite.dart';

enum KiteSidebarPosition { start, end }

/// Fixed-width sidebar + flexible content layout.
///
/// Compact or insufficient local width:
/// - Returns only [content].
///
/// Medium / Expanded with enough local width:
/// - Shows sidebar + content.
/// - Each pane may scroll independently.
///
/// Important:
/// When the sidebar is visible this widget requires bounded height because it
/// manages pane scrolling internally. Do not place the expanded split inside a
/// vertical SingleChildScrollView.
class KiteSplitLayout extends StatefulWidget {
  const KiteSplitLayout({
    required this.sidebar,
    required this.content,
    this.sidebarWidth = 280,
    this.mediumSidebarWidth = 240,
    this.minContentWidth = 320,
    this.gap = Dimensions.s24,
    this.sidebarPosition = KiteSidebarPosition.start,
    this.sidebarScrollable = false,
    this.contentScrollable = true,
    super.key,
  }) : assert(sidebarWidth > 0, 'sidebarWidth must be greater than zero.'),
       assert(
         mediumSidebarWidth > 0,
         'mediumSidebarWidth must be greater than zero.',
       ),
       assert(
         minContentWidth > 0,
         'minContentWidth must be greater than zero.',
       ),
       assert(gap >= 0, 'gap cannot be negative.');

  final Widget sidebar;
  final Widget content;

  final double sidebarWidth;
  final double mediumSidebarWidth;
  final double minContentWidth;
  final double gap;

  final KiteSidebarPosition sidebarPosition;

  final bool sidebarScrollable;
  final bool contentScrollable;

  @override
  State<KiteSplitLayout> createState() => _KiteSplitLayoutState();
}

class _KiteSplitLayoutState extends State<KiteSplitLayout> {
  final ScrollController _sidebarController = ScrollController();
  final ScrollController _contentController = ScrollController();

  @override
  void dispose() {
    _sidebarController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final viewportWidth = context.responsiveWidth;
        final availableWidth = constraints.maxWidth.isFinite
            ? math.min(constraints.maxWidth, viewportWidth)
            : viewportWidth;
        final layoutSize = KiteBreakpoints.resolve(availableWidth);

        final sidebarWidth = switch (layoutSize) {
          KiteLayoutSize.compact => widget.mediumSidebarWidth,
          KiteLayoutSize.medium => widget.mediumSidebarWidth,
          KiteLayoutSize.expanded => widget.sidebarWidth,
        };

        final hasEnoughWidth =
            availableWidth >=
            sidebarWidth + widget.gap + widget.minContentWidth;
        final showSidebar =
            layoutSize != KiteLayoutSize.compact && hasEnoughWidth;

        if (!showSidebar) {
          return _pane(
            child: widget.content,
            scrollable: widget.contentScrollable,
            controller: _contentController,
          );
        }

        if (!constraints.hasBoundedWidth || !constraints.maxWidth.isFinite) {
          throw FlutterError.fromParts([
            ErrorSummary('KiteSplitLayout requires a bounded width.'),
            ErrorDescription(
              'The sidebar layout needs finite horizontal constraints to '
              'reserve sidebar and content widths safely.',
            ),
            ErrorHint(
              'Place KiteSplitLayout inside a bounded page or Expanded region.',
            ),
          ]);
        }

        if (!constraints.hasBoundedHeight) {
          throw FlutterError.fromParts([
            ErrorSummary('KiteSplitLayout requires a bounded height.'),
            ErrorDescription(
              'KiteSplitLayout manages sidebar/content scrolling internally '
              'while the sidebar is visible and cannot be placed inside an '
              'unbounded vertical scroll view.',
            ),
            ErrorHint(
              'If using KitePage, set scrollable: false and give the split '
              'layout the remaining bounded height.',
            ),
          ]);
        }

        final sidebar = SizedBox(
          width: sidebarWidth,
          child: _pane(
            child: widget.sidebar,
            scrollable: widget.sidebarScrollable,
            controller: _sidebarController,
          ),
        );

        final content = Expanded(
          child: _pane(
            child: widget.content,
            scrollable: widget.contentScrollable,
            controller: _contentController,
          ),
        );

        final children = switch (widget.sidebarPosition) {
          KiteSidebarPosition.start => <Widget>[
            sidebar,
            SizedBox(width: widget.gap),
            content,
          ],
          KiteSidebarPosition.end => <Widget>[
            content,
            SizedBox(width: widget.gap),
            sidebar,
          ],
        };

        return Row(
          textDirection: Directionality.of(context),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        );
      },
    );
  }

  Widget _pane({
    required Widget child,
    required bool scrollable,
    required ScrollController controller,
  }) {
    if (!scrollable) {
      return child;
    }

    return Scrollbar(
      controller: controller,
      child: SingleChildScrollView(
        controller: controller,
        primary: false,
        child: child,
      ),
    );
  }
}
