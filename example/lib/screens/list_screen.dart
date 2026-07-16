import 'package:flutter/material.dart';
import 'package:kite/kite.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({required this.title, required this.icon, super.key});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return KitePage(
      title: title,
      subtitle: 'A compact card list becomes a desktop table automatically.',
      primaryAction: FilledButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: Text('Add $title'),
      ),
      child: KiteRepresentation(
        compact: _Cards(title: title, icon: icon),
        expanded: _Table(title: title),
      ),
    );
  }
}

class _Cards extends StatelessWidget {
  const _Cards({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        12,
        (index) => Card(
          child: ListTile(
            leading: Icon(icon),
            title: Text('$title item ${index + 1}'),
            subtitle: const Text('Responsive compact representation'),
            trailing: const Icon(Icons.chevron_right),
          ),
        ),
      ),
    );
  }
}

class _Table extends StatelessWidget {
  const _Table({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Created')),
            DataColumn(label: Text('Owner')),
          ],
          rows: List.generate(
            12,
            (index) => DataRow(
              cells: [
                DataCell(Text('$title item ${index + 1}')),
                const DataCell(Text('Active')),
                const DataCell(Text('July 2026')),
                const DataCell(Text('Sakil Ahmed')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
