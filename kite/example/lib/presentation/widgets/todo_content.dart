import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../lib/shared/components/kite_button.dart';
import '../../../../lib/shared/widgets/app_empty_view.dart';
import '../../../../lib/shared/widgets/app_error_view.dart';
import '../../../../lib/shared/widgets/app_loading_view.dart';
import '../providers/todo_providers.dart';
import 'todo_filter_bar.dart';
import 'todo_tile.dart';

class TodoContent extends ConsumerWidget {
  const TodoContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(filteredTodosProvider);
    final summary = ref.watch(todoSummaryProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return RefreshIndicator.adaptive(
      onRefresh: ref.read(todoListProvider.notifier).refresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar.large(
            pinned: true,
            title: const Text('Kite Todo'),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: KiteButton(
                  variant: KiteButtonVariant.tonal,
                  tooltip: 'Refresh todos',
                  onPressed: ref.read(todoListProvider.notifier).refresh,
                  leading: const Icon(Icons.refresh_rounded),
                  child: const Text('Refresh'),
                ),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          colorScheme.primaryContainer,
                          colorScheme.tertiaryContainer,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.air_rounded,
                          size: 40,
                          color: colorScheme.onPrimaryContainer,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${summary.completed} of '
                                '${summary.total} completed',
                                style: textTheme.titleLarge?.copyWith(
                                  color: colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Generated with Kite, powered by '
                                'JSONPlaceholder.',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: TodoFilterBar(),
                  ),
                ],
              ),
            ),
          ),
          todos.when(
            loading: () => const SliverFillRemaining(
              hasScrollBody: false,
              child: AppLoadingView(message: 'Loading todos…'),
            ),
            error: (error, stackTrace) => SliverFillRemaining(
              hasScrollBody: false,
              child: AppErrorView(
                message: error.toString(),
                onRetry: ref.read(todoListProvider.notifier).refresh,
              ),
            ),
            data: (items) {
              if (items.isEmpty) {
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: AppEmptyView(
                    title: 'Nothing here',
                    message: 'Choose another filter to see more todos.',
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                sliver: SliverList.separated(
                  itemCount: items.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 4),
                  itemBuilder: (context, index) {
                    final todo = items[index];
                    return TodoTile(
                      todo: todo,
                      onToggle: () {
                        ref.read(todoListProvider.notifier).toggle(todo.id);
                      },
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
