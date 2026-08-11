import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import '../dimension.dart';
import 'responsive_kite.dart';

class KiteGrid extends StatelessWidget {
  const KiteGrid({
    required this.children,
    this.compactColumns = 1,
    this.mediumColumns = 2,
    this.expandedColumns = 3,
    this.gap = Dimensions.s16,
    super.key,
  }) : assert(compactColumns > 0, 'compactColumns must be greater than zero.'),
       assert(mediumColumns > 0, 'mediumColumns must be greater than zero.'),
       assert(
         expandedColumns > 0,
         'expandedColumns must be greater than zero.',
       ),
       assert(gap >= 0, 'gap cannot be negative.');

  final List<Widget> children;
  final int compactColumns;
  final int mediumColumns;
  final int expandedColumns;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (!constraints.hasBoundedWidth || !constraints.maxWidth.isFinite) {
          throw FlutterError.fromParts([
            ErrorSummary('KiteGrid requires a bounded width.'),
            ErrorDescription(
              'KiteGrid calculates responsive column widths from the space '
              'allocated by its parent.',
            ),
            ErrorHint(
              'Place KiteGrid in a widget that provides a finite width, such '
              'as KitePage, Expanded, SizedBox, or a constrained pane.',
            ),
          ]);
        }

        final availableWidth = math.min(
          constraints.maxWidth,
          context.responsiveWidth,
        );
        final layoutSize = KiteBreakpoints.resolve(availableWidth);
        final columns = switch (layoutSize) {
          KiteLayoutSize.compact => compactColumns,
          KiteLayoutSize.medium => mediumColumns,
          KiteLayoutSize.expanded => expandedColumns,
        };

        final totalGap = gap * (columns - 1);

        if (totalGap >= availableWidth && columns > 1) {
          throw FlutterError.fromParts([
            ErrorSummary('KiteGrid gap is too large for the available width.'),
            ErrorDescription(
              'The configured horizontal gaps consume all available grid width.',
            ),
            ErrorHint(
              'Reduce gap or reduce the column count for this responsive size.',
            ),
          ]);
        }

        final baseWidth = (availableWidth - totalGap) / columns;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final widget in children)
              _buildItem(
                widget: widget,
                layoutSize: layoutSize,
                columns: columns,
                baseWidth: baseWidth,
              ),
          ],
        );
      },
    );
  }

  Widget _buildItem({
    required Widget widget,
    required KiteLayoutSize layoutSize,
    required int columns,
    required double baseWidth,
  }) {
    final item = widget is KiteGridItem ? widget : null;
    final child = item?.child ?? widget;

    final requestedSpan = item?.resolveSpan(layoutSize, columns) ?? 1;
    final span = requestedSpan.clamp(1, columns).toInt();
    final width = (baseWidth * span) + (gap * (span - 1));

    return SizedBox(width: width, child: child);
  }
}

class KiteGridItem extends StatelessWidget {
  const KiteGridItem({
    required this.child,
    this.span = 1,
    this.compactSpan,
    this.mediumSpan,
    this.expandedSpan,
    super.key,
  }) : assert(span > 0, 'span must be greater than zero.'),
       assert(
         compactSpan == null || compactSpan > 0,
         'compactSpan must be greater than zero when provided.',
       ),
       assert(
         mediumSpan == null || mediumSpan > 0,
         'mediumSpan must be greater than zero when provided.',
       ),
       assert(
         expandedSpan == null || expandedSpan > 0,
         'expandedSpan must be greater than zero when provided.',
       ),
       full = false;

  const KiteGridItem.full({required this.child, super.key})
    : span = 1,
      compactSpan = null,
      mediumSpan = null,
      expandedSpan = null,
      full = true;

  final Widget child;
  final int span;
  final int? compactSpan;
  final int? mediumSpan;
  final int? expandedSpan;
  final bool full;

  int resolveSpan(KiteLayoutSize layoutSize, int columns) {
    if (full) return columns;

    return switch (layoutSize) {
      KiteLayoutSize.compact => compactSpan ?? span,
      KiteLayoutSize.medium => mediumSpan ?? compactSpan ?? span,
      KiteLayoutSize.expanded =>
        expandedSpan ?? mediumSpan ?? compactSpan ?? span,
    };
  }

  @override
  Widget build(BuildContext context) => child;
}
