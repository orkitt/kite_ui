import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../lib/core/network/dio/dio_providers.dart';
import '../../../../lib/core/result/result.dart';
import '../../../../lib/core/state/async_notifier_guard.dart';
import '../../../../lib/features/todo/data/repositories/todo_repository_impl.dart';
import '../../../../lib/features/todo/data/sources/todo_remote_source.dart';
import '../../../../lib/features/todo/domain/entities/todo_entity.dart';
import '../../../../lib/features/todo/domain/repositories/todo_repository.dart';
import '../../../../lib/features/todo/domain/usecases/get_todo_use_case.dart';

enum TodoFilter { all, active, completed }

final todoRemoteSourceProvider = Provider<TodoRemoteSource>((ref) {
  return TodoRemoteSourceImpl(client: ref.watch(dioApiClientProvider));
});

final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  return TodoRepositoryImpl(
    remoteSource: ref.watch(todoRemoteSourceProvider),
  );
});

final getTodoUseCaseProvider = Provider<GetTodoUseCase>((ref) {
  return GetTodoUseCase(repository: ref.watch(todoRepositoryProvider));
});

final todoFilterProvider =
    NotifierProvider<TodoFilterNotifier, TodoFilter>(TodoFilterNotifier.new);

final todoListProvider =
    AsyncNotifierProvider<TodoListNotifier, List<TodoEntity>>(
  TodoListNotifier.new,
);

final filteredTodosProvider = Provider<AsyncValue<List<TodoEntity>>>((ref) {
  final todos = ref.watch(todoListProvider);
  final filter = ref.watch(todoFilterProvider);

  return todos.whenData((items) {
    return switch (filter) {
      TodoFilter.all => items,
      TodoFilter.active =>
        items.where((todo) => !todo.completed).toList(growable: false),
      TodoFilter.completed =>
        items.where((todo) => todo.completed).toList(growable: false),
    };
  });
});

final todoSummaryProvider = Provider<({int total, int completed})>((ref) {
  final items = switch (ref.watch(todoListProvider)) {
    AsyncData(:final value) => value,
    _ => const <TodoEntity>[],
  };
  return (
    total: items.length,
    completed: items.where((todo) => todo.completed).length,
  );
});

final class TodoFilterNotifier extends Notifier<TodoFilter> {
  @override
  TodoFilter build() => TodoFilter.all;

  void select(TodoFilter value) {
    state = value;
  }
}

final class TodoListNotifier extends AsyncNotifier<List<TodoEntity>>
    with AsyncNotifierGuard<List<TodoEntity>> {
  @override
  FutureOr<List<TodoEntity>> build() => _loadTodos();

  Future<List<TodoEntity>> _loadTodos() async {
    final result = await ref.read(getTodoUseCaseProvider).call();
    return switch (result) {
      Success<List<TodoEntity>>(:final value) => value,
      Failure<List<TodoEntity>>(:final failure) =>
        throw StateError(failure.message),
    };
  }

  Future<void> refresh() => runGuarded(_loadTodos);

  void toggle(int id) {
    final current = switch (state) {
      AsyncData(:final value) => value,
      _ => null,
    };
    if (current == null) {
      return;
    }

    state = AsyncData<List<TodoEntity>>(
      current
          .map(
            (todo) => todo.id == id
                ? todo.copyWith(completed: !todo.completed)
                : todo,
          )
          .toList(growable: false),
    );
  }
}
