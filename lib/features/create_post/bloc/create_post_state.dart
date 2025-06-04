// lib/features/create_post/bloc/create_post_state.dart

import 'package:equatable/equatable.dart';
import '../../../data/models/post_model.dart';

abstract class CreatePostState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreatePostInitial extends CreatePostState {}

class CreatePostLoading extends CreatePostState {}

class CreatePostSuccess extends CreatePostState {
  final Post post;

  CreatePostSuccess({required this.post});

  @override
  List<Object?> get props => [post];
}

class CreatePostFailure extends CreatePostState {
  final String error;

  CreatePostFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
