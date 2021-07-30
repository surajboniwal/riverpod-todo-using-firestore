import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/controllers/todo_controller.dart';
import 'package:riverpod_test/models/todo.dart';

class AddTodoDialog extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add todo'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Form(
            key: _key,
            child: TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Todo',
              ),
              validator: (val) {
                if (val?.isEmpty == true || val == null) {
                  return 'Todo is required';
                }
                return null;
              },
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_key.currentState?.validate() ?? false) {
              context.read(TodoController.todoControllerProvider.notifier).createTodo(
                    Todo(name: _controller.text, status: false),
                  );
              Navigator.of(context).pop();
            }
          },
          child: Text('Add'),
        )
      ],
    );
  }
}
