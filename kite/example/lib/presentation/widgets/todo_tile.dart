import 'package:flutter/material.dart';

import '../../../../lib/shared/components/kite_card.dart';
import '../../../../lib/features/todo/domain/entities/todo_entity.dart';

class TodoTile extends StatelessWidget {
  const TodoTile({
    super.key,
    required this.todo,
    required this.onToggle,
  });

  final TodoEntity todo;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return KiteCard(
      selected: todo.completed,
      onTap: onToggle,
      semanticLabel: todo.title,
      child: Row(
        children: <Widget>[
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: todo.completed
                  ? colorScheme.primaryContainer
                  : colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              todo.completed
                  ? Icons.check_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: todo.completed
                  ? colorScheme.onPrimaryContainer
                  : colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  todo.title,
                  style: textTheme.titleMedium?.copyWith(
                    decoration:
                        todo.completed ? TextDecoration.lineThrough : null,
                    color: todo.completed
                        ? colorScheme.onSurfaceVariant
                        : colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Todo #${todo.id} • User ${todo.userId}',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Checkbox.adaptive(
            value: todo.completed,
            onChanged: (_) => onToggle(),
          ),
        ],
      ),
    );
  }
}
