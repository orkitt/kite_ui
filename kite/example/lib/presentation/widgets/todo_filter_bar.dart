import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/todo_providers.dart';

class TodoFilterBar extends ConsumerWidget {
  const TodoFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(todoFilterProvider);

    return SegmentedButton<TodoFilter>(
      segments: const <ButtonSegment<TodoFilter>>[
        ButtonSegment<TodoFilter>(
          value: TodoFilter.all,
          icon: Icon(Icons.list_alt_rounded),
          label: Text('All'),
        ),
        ButtonSegment<TodoFilter>(
          value: TodoFilter.active,
          icon: Icon(Icons.pending_actions_rounded),
          label: Text('Active'),
        ),
        ButtonSegment<TodoFilter>(
          value: TodoFilter.completed,
          icon: Icon(Icons.task_alt_rounded),
          label: Text('Done'),
        ),
      ],
      selected: <TodoFilter>{selected},
      onSelectionChanged: (selection) {
        ref.read(todoFilterProvider.notifier).select(selection.single);
      },
      showSelectedIcon: false,
    );
  }
}
