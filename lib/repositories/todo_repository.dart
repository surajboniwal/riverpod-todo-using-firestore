import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/controllers/auth_controller.dart';
import 'package:riverpod_test/models/todo.dart';
import 'package:riverpod_test/providers/firebase_providers.dart';

abstract class BaseTodoRepository {
  Future<String> createTodo(Todo movie);
  Future<void> removeTodo(String id);
  Future<void> editTodo(Todo todo);
  Future<List<Todo>> getTodos();
}

class TodoRepository implements BaseTodoRepository {
  Reader _read;

  TodoRepository(this._read);

  static final todoRepositoryProvider = Provider<TodoRepository>((ref) {
    return TodoRepository(ref.read);
  });

  @override
  Future<String> createTodo(Todo todo) async {
    final _firestore = _read(FirebaseProviders.firebaseFirestoreProvider);
    final _todos = _firestore.collection('users').doc(_read(AuthController.authControllerProvider)?.uid).collection('todos');
    final _todo = await _todos.add(todo.toMap());
    return _todo.id;
  }

  @override
  Future<void> editTodo(Todo todo) async {
    final _firestore = _read(FirebaseProviders.firebaseFirestoreProvider);
    _firestore.collection('users').doc(_read(AuthController.authControllerProvider)?.uid).collection('todos').doc(todo.id).update(todo.toMap());
  }

  @override
  Future<List<Todo>> getTodos() async {
    final _todos = await _read(FirebaseProviders.firebaseFirestoreProvider).collection('users').doc(_read(AuthController.authControllerProvider)?.uid).collection('todos').get();
    return _todos.docs.map((e) => Todo.fromDocument(e)).toList();
  }

  @override
  Future<void> removeTodo(String id) async {
    final _firestore = _read(FirebaseProviders.firebaseFirestoreProvider);
    _firestore.collection('users').doc(_read(AuthController.authControllerProvider)?.uid).collection('todos').doc(id).delete();
  }
}
