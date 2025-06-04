class ApiConstants {
  static const String baseUrl = 'https://dummyjson.com';
  static const String users = '$baseUrl/users';
  static String userPosts(int id) => '$baseUrl/posts/user/$id';
  static String userTodos(int id) => '$baseUrl/todos/user/$id';
}
