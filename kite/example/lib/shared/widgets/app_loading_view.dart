import 'package:flutter/material.dart';

class AppLoadingView extends StatelessWidget {
  const AppLoadingView({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const CircularProgressIndicator.adaptive(),
          if (message case final message?) ...<Widget>[
            const SizedBox(height: 16),
            Text(message, style: textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}
