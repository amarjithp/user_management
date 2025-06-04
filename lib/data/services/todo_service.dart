import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/todo_model.dart';

class TodoService {
  Future<List<Todo>> fetchTodosByUser(int userId) async {
    final url = Uri.parse('https://dummyjson.com/todos/user/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['todos'] as List).map((e) => Todo.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }
}
