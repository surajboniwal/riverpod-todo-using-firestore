import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/models/todo.dart';
import 'package:riverpod_test/repositories/todo_repository.dart';

class TodoController extends StateNotifier<AsyncValue<List<Todo>>> {
  TodoController(this._read) : super(AsyncValue.loading()) {
    getTodos();
  }

  Reader _read;

  static final todoControllerProvider = StateNotifierProvider<TodoController, AsyncValue<List<Todo>>>((ref) {
    return TodoController(ref.read);
  });

  Future<void> getTodos() async {
    final _todoRepository = _read(TodoRepository.todoRepositoryProvider);

    final _todos = await _todoRepository.getTodos();

    state = AsyncValue.data(_todos);
  }

  Future<void> editTodo(Todo todo) async {
    todo.status = !(todo.status ?? true);
    _read(TodoRepository.todoRepositoryProvider).editTodo(todo);
    state.whenData((value) {
      state = AsyncValue.data([
        for (final item in value)
          if (item.id == todo.id) todo else item
      ]);
    });
  }

  Future<void> createTodo(Todo todo) async {
    final _todoRepository = _read(TodoRepository.todoRepositoryProvider);
    final id = await _todoRepository.createTodo(todo);
    state.whenData((value) => state = AsyncValue.data(value..add(todo.copyWith(id: id))));
  }

  Future<void> removeTodo(String id) async {
    final _todoRepository = _read(TodoRepository.todoRepositoryProvider);
    _todoRepository.removeTodo(id);
    state.whenData((value) {
      value.removeWhere((e) => e.id == id);
      state = AsyncValue.data(value);
    });
  }
}
