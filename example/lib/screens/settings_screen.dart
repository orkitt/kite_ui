import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kite/kite.dart';

class SettingsShell extends StatelessWidget {
  const SettingsShell({required this.location, required this.child, super.key});

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return KitePage(
      title: 'Settings',
      subtitle: 'Route-driven master-detail navigation.',
      child: KiteRouteMasterDetail(
        rootRoute: '/settings',
        currentLocation: location,
        master: const _SettingsNavigation(),
        detail: child,
        mobileTitle: _titleFor(location),
      ),
    );
  }

  String _titleFor(String location) {
    if (location.endsWith('profile')) return 'User profile';
    if (location.endsWith('appearance')) return 'Appearance';
    if (location.endsWith('notifications')) return 'Notifications';
    if (location.endsWith('security')) return 'Security';
    if (location.endsWith('billing')) return 'Billing';
    return 'User profile';
  }
}

class _SettingsNavigation extends StatelessWidget {
  const _SettingsNavigation();

  static const destinations = <({String label, String route, IconData icon})>[
    (label: 'User profile', route: '/settings/profile', icon: Icons.person_outline),
    (label: 'Appearance', route: '/settings/appearance', icon: Icons.palette_outlined),
    (label: 'Notifications', route: '/settings/notifications', icon: Icons.notifications_none),
    (label: 'Security', route: '/settings/security', icon: Icons.shield_outlined),
    (label: 'Billing', route: '/settings/billing', icon: Icons.credit_card_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            for (final destination in destinations)
              ListTile(
                selected: destination.route == location ||
                    (location == '/settings' &&
                        destination.route == '/settings/profile'),
                leading: Icon(destination.icon),
                title: Text(destination.label),
                trailing: const Icon(Icons.chevron_right),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                onTap: () => context.openKiteDetail(destination.route),
              ),
          ],
        ),
      ),
    );
  }
}

class ProfileSettingsPage extends StatelessWidget {
  const ProfileSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SettingsPanel(
      title: 'User profile',
      icon: Icons.person_outline,
      children: [
        TextField(decoration: InputDecoration(labelText: 'First name')),
        SizedBox(height: 14),
        TextField(decoration: InputDecoration(labelText: 'Last name')),
        SizedBox(height: 14),
        TextField(decoration: InputDecoration(labelText: 'Email')),
      ],
    );
  }
}

class SettingsDetailPage extends StatelessWidget {
  const SettingsDetailPage({required this.title, required this.icon, super.key});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return _SettingsPanel(
      title: title,
      icon: icon,
      children: const [
        SwitchListTile(value: true, onChanged: null, title: Text('Example preference')),
        Divider(),
        SwitchListTile(value: false, onChanged: null, title: Text('Another preference')),
      ],
    );
  }
}

class _SettingsPanel extends StatelessWidget {
  const _SettingsPanel({required this.title, required this.icon, required this.children});

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(icon),
                const SizedBox(width: 10),
                Text(title, style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }
}
