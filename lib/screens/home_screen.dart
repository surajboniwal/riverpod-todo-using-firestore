import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/controllers/auth_controller.dart';
import 'package:riverpod_test/controllers/todo_controller.dart';
import 'package:riverpod_test/widgets/add_todo.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddTodoDialog(),
          );
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text('Riverpod Todo'),
        actions: [
          IconButton(
            onPressed: () {
              context.read(AuthController.authControllerProvider.notifier).signOut();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Consumer(
        builder: (context, watch, child) {
          final user = watch(AuthController.authControllerProvider);
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ListTile(
                  title: Text(
                    user?.displayName ?? 'No user',
                  ),
                  subtitle: Text(user?.email ?? 'No email'),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      user?.photoURL ?? 'https://img-authors.flaticon.com/google.jpg',
                    ),
                  ),
                ),
                Divider(),
                Consumer(
                  builder: (context, watch, child) {
                    final movieController = watch(TodoController.todoControllerProvider);
                    return movieController.when(
                      data: (data) => ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: data.length,
                        itemBuilder: (context, index) => ListTile(
                          title: Text(data[index].name ?? 'No data'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                onChanged: (val) {
                                  context.read(TodoController.todoControllerProvider.notifier).editTodo(data[index]);
                                },
                                value: data[index].status,
                              ),
                              IconButton(
                                onPressed: () {
                                  context.read(TodoController.todoControllerProvider.notifier).removeTodo(data[index].id ?? 'id');
                                },
                                icon: Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                      ),
                      loading: () => CircularProgressIndicator.adaptive(),
                      error: (error, stackTrace) => Center(
                        child: Text(error.toString()),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
