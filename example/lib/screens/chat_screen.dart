import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kite/kite.dart';

class ChatShell extends StatelessWidget {
  const ChatShell({required this.location, required this.child, super.key});

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return KitePage(
      title: 'Support chat',
      subtitle: 'Master-detail navigation with an optional third information pane.',
      child: KiteRouteMasterDetail(
        rootRoute: '/chat',
        currentLocation: location,
        masterWidth: 310,
        master: const _ConversationList(),
        detail: child,
        mobileTitle: 'Conversation',
      ),
    );
  }
}

class ChatPlaceholder extends StatelessWidget {
  const ChatPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: SizedBox(
        height: 560,
        child: Center(child: Text('Select a conversation')),
      ),
    );
  }
}

class ChatConversation extends StatelessWidget {
  const ChatConversation({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context) {
    return KiteSplitView(
      sideBySideFrom: KiteLayoutSize.large,
      primaryFlex: 3,
      secondaryFlex: 1,
      primary: _MessagePanel(id: id),
      secondary: const _ContactPanel(),
    );
  }
}

class _ConversationList extends StatelessWidget {
  const _ConversationList();

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    return Card(
      child: SizedBox(
        height: 560,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(12),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search conversations',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                itemCount: 12,
                itemBuilder: (context, index) {
                  final route = '/chat/customer-${index + 1}';
                  return ListTile(
                    selected: location == route,
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text('Customer ${index + 1}'),
                    subtitle: const Text('I need help with my order...'),
                    trailing: const Text('2m'),
                    onTap: () => context.openKiteDetail(route),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessagePanel extends StatelessWidget {
  const _MessagePanel({required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 560,
        child: Column(
          children: [
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(id.replaceAll('-', ' ')),
              subtitle: const Text('Online'),
              trailing: const Icon(Icons.more_horiz),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: const [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: _Bubble(text: 'Hi, I need help with an order.'),
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: _Bubble(text: 'Of course. What is your order number?', own: true),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(12),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Write a message',
                  suffixIcon: Icon(Icons.send),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.text, this.own = false});

  final String text;
  final bool own;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      constraints: const BoxConstraints(maxWidth: 320),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: own ? colors.primaryContainer : colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(text),
    );
  }
}

class _ContactPanel extends StatelessWidget {
  const _ContactPanel();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: SizedBox(
        height: 560,
        child: Padding(
          padding: EdgeInsets.all(18),
          child: Column(
            children: [
              CircleAvatar(radius: 34, child: Icon(Icons.person, size: 34)),
              SizedBox(height: 12),
              Text('Customer profile', style: TextStyle(fontWeight: FontWeight.w700)),
              SizedBox(height: 6),
              Text('customer@example.com'),
              Divider(height: 32),
              ListTile(leading: Icon(Icons.shopping_bag_outlined), title: Text('12 orders')),
              ListTile(leading: Icon(Icons.payments_outlined), title: Text('\$1,840 spent')),
            ],
          ),
        ),
      ),
    );
  }
}
