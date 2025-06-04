import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/post_model.dart';
import '../../../data/models/todo_model.dart';
import '../../../data/services/post_service.dart';
import '../../../data/services/todo_service.dart';
import 'user_detail_event.dart';
import 'user_detail_state.dart';

class UserDetailBloc extends Bloc<UserDetailEvent, UserDetailState> {
  final PostService postService = PostService();
  final TodoService todoService = TodoService();

  UserDetailBloc() : super(const UserDetailState()) {
    on<LoadUserDetail>(_onLoadDetail);
  }

  Future<void> _onLoadDetail(
      LoadUserDetail event, Emitter<UserDetailState> emit) async {
    emit(state.copyWith(status: DetailStatus.loading));
    try {
      final posts = await postService.fetchPostsByUser(event.userId);
      final todos = await todoService.fetchTodosByUser(event.userId);
      emit(state.copyWith(
        status: DetailStatus.success,
        posts: posts,
        todos: todos,
      ));
    } catch (e) {
      emit(state.copyWith(status: DetailStatus.failure, error: e.toString()));
    }
  }
}
