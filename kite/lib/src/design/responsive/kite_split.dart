import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../dimension.dart';
import 'responsive_kite.dart';

/// Two proportional content regions that stack automatically when the space
/// allocated to this widget is compact.
class KiteSplit extends StatelessWidget {
  const KiteSplit({
    required this.left,
    required this.right,
    this.leftFlex = 1,
    this.rightFlex = 1,
    this.gap = Dimensions.s16,
    this.stackOnCompact = true,
    super.key,
  }) : assert(leftFlex > 0, 'leftFlex must be greater than zero.'),
       assert(rightFlex > 0, 'rightFlex must be greater than zero.'),
       assert(gap >= 0, 'gap cannot be negative.');

  final Widget left;
  final Widget right;
  final int leftFlex;
  final int rightFlex;
  final double gap;
  final bool stackOnCompact;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final viewportWidth = context.responsiveWidth;
        final availableWidth = constraints.maxWidth.isFinite
            ? math.min(constraints.maxWidth, viewportWidth)
            : viewportWidth;
        final layoutSize = KiteBreakpoints.resolve(availableWidth);

        if (stackOnCompact && layoutSize == KiteLayoutSize.compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              left,
              SizedBox(height: gap),
              right,
            ],
          );
        }

        if (!constraints.hasBoundedWidth || !constraints.maxWidth.isFinite) {
          throw FlutterError.fromParts([
            ErrorSummary('KiteSplit requires a bounded width when horizontal.'),
            ErrorDescription(
              'A horizontal KiteSplit uses Expanded children and therefore '
              'needs finite horizontal constraints.',
            ),
            ErrorHint(
              'Constrain the split width or enable stackOnCompact when the '
              'available region can become narrow.',
            ),
          ]);
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: leftFlex, child: left),
            SizedBox(width: gap),
            Expanded(flex: rightFlex, child: right),
          ],
        );
      },
    );
  }
}
