// lib/features/create_post/bloc/create_post_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'create_post_event.dart';
import 'create_post_state.dart';
import '../../../data/services/post_service.dart';

class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  final PostService postService;

  CreatePostBloc({required this.postService}) : super(CreatePostInitial()) {
    on<CreatePostSubmitted>((event, emit) async {
      emit(CreatePostLoading());

      try {
        final post = await postService.createPostLocally(
          userId: event.userId,
          title: event.title,
          body: event.body,
        );
        emit(CreatePostSuccess(post: post));
      } catch (e) {
        emit(CreatePostFailure(error: e.toString()));
      }
    });
  }
}
