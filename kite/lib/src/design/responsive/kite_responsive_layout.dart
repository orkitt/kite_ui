import 'package:flutter/widgets.dart';

import 'responsive_kite.dart';

class KiteResponsiveLayout extends StatelessWidget {
  const KiteResponsiveLayout({
    required this.compact,
    this.medium,
    this.expanded,
    super.key,
  });

  final Widget compact;
  final Widget? medium;
  final Widget? expanded;

  @override
  Widget build(BuildContext context) {
    return context.responsive(
      compact: compact,
      medium: medium,
      expanded: expanded,
    );
  }
}
