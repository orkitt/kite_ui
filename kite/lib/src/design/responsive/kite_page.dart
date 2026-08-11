import 'package:flutter/widgets.dart';

import 'responsive_kite.dart';

class KitePage extends StatelessWidget {
  const KitePage({
    required this.child,
    this.maxWidth = 1280,
    this.padding,
    this.scrollable = true,
    super.key,
  }) : assert(maxWidth > 0, 'maxWidth must be greater than zero.');

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final content = Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: padding ?? context.layoutSize.pageInsets,
            child: child,
          ),
        ),
      ),
    );

    if (!scrollable) {
      return content;
    }

    return SingleChildScrollView(child: content);
  }
}
