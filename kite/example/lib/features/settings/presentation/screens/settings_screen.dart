import 'package:example/shared/widgets/theme_changer.dart';
import 'package:flutter/material.dart';

import '../widgets/settings_content.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SafeArea(child: ThemeChanger()));
  }
}
