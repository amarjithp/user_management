import '../../../data/models/post_model.dart';
import '../../../data/models/todo_model.dart';

enum DetailStatus { initial, loading, success, failure }

class UserDetailState {
  final DetailStatus status;
  final List<Post> posts;
  final List<Todo> todos;
  final String? error;

  const UserDetailState({
    this.status = DetailStatus.initial,
    this.posts = const [],
    this.todos = const [],
    this.error,
  });

  UserDetailState copyWith({
    DetailStatus? status,
    List<Post>? posts,
    List<Todo>? todos,
    String? error,
  }) {
    return UserDetailState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      todos: todos ?? this.todos,
      error: error ?? this.error,
    );
  }
}
