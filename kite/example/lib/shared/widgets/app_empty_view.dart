import 'package:flutter/material.dart';

class AppEmptyView extends StatelessWidget {
  const AppEmptyView({
    super.key,
    required this.title,
    this.message,
    this.icon = Icons.inbox_outlined,
    this.action,
  });

  final String title;
  final String? message;
  final IconData icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 48, color: colorScheme.primary),
            const SizedBox(height: 16),
            Text(title, style: textTheme.titleLarge),
            if (message case final message?) ...<Widget>[
              const SizedBox(height: 8),
              Text(
                message,
                style: textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
            if (action case final action?) ...<Widget>[
              const SizedBox(height: 20),
              action,
            ],
          ],
        ),
      ),
    );
  }
}
