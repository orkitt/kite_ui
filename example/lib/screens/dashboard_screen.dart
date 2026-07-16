import 'package:flutter/material.dart';
import 'package:kite/kite.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return KitePage(
      title: 'Dashboard',
      subtitle: 'The same content adapts from mobile to wide desktop.',
      primaryAction: FilledButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('Create order'),
      ),
      child: Column(
        children: [
          KiteGrid.extent(
            minItemWidth: 220,
            maxColumns: 4,
            children: const [
              _MetricCard(label: 'Revenue', value: '\$124,580', change: '+18.4%'),
              _MetricCard(label: 'Orders', value: '8,492', change: '+8.2%'),
              _MetricCard(label: 'Customers', value: '24,102', change: '+11.6%'),
              _MetricCard(label: 'Conversion', value: '3.84%', change: '+0.6%'),
            ],
          ),
          const SizedBox(height: 16),
          const KiteSplitView(
            primary: _Panel(title: 'Revenue overview', height: 330),
            secondary: _Panel(title: 'Top channels', height: 330),
          ),
          const SizedBox(height: 16),
          const KiteRepresentation(
            compact: _MobileOrders(),
            expanded: _DesktopOrders(),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.label, required this.value, required this.change});

  final String label;
  final String value;
  final String change;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 12),
            Text(value, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(change, style: TextStyle(color: theme.colorScheme.primary)),
          ],
        ),
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.title, required this.height});

  final String title;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: height,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const Expanded(
                child: Center(child: Icon(Icons.show_chart, size: 80)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MobileOrders extends StatelessWidget {
  const _MobileOrders();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        4,
        (index) => Card(
          child: ListTile(
            leading: CircleAvatar(child: Text('${index + 1}')),
            title: Text('Order #10${index + 1}'),
            subtitle: const Text('Processing'),
            trailing: Text('\$${(index + 1) * 84}.00'),
          ),
        ),
      ),
    );
  }
}

class _DesktopOrders extends StatelessWidget {
  const _DesktopOrders();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Order')),
            DataColumn(label: Text('Customer')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Total')),
          ],
          rows: List.generate(
            5,
            (index) => DataRow(
              cells: [
                DataCell(Text('#10${index + 1}')),
                DataCell(Text('Customer ${index + 1}')),
                const DataCell(Text('Processing')),
                DataCell(Text('\$${(index + 1) * 84}.00')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
