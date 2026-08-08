import 'package:example/core/constants/app_colors.dart';
import 'package:example/core/constants/app_typography.dart';
import 'package:flutter/material.dart';

class AppStartupView extends StatelessWidget {
  final IconData? icon;
  const AppStartupView({super.key, this.icon});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colors;
    final textStyle = context.typography;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 72,
                  height: 72,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colorScheme.primarySoft,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    icon ?? Icons.air_rounded,
                    size: 36,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 20),
              Text('Kite is Flying', style: textStyle.headingMedium),

                const SizedBox(height: 8),

                Text(
                  'Your Kite foundation is ready.\nStart building something awesome.',
                  style: textStyle.body,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
