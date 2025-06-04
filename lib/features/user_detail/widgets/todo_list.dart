import 'package:flutter/material.dart';
import '../../../data/models/todo_model.dart';

class TodoList extends StatelessWidget {
  final List<Todo> todos;
  const TodoList({super.key, required this.todos});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: todos.map((t) => CheckboxListTile(
        value: t.completed,
        onChanged: null,
        title: Text(t.todo),
      )).toList(),
    );
  }
}
