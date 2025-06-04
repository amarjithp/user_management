// lib/features/create_post/bloc/create_post_event.dart

import 'package:equatable/equatable.dart';

abstract class CreatePostEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreatePostSubmitted extends CreatePostEvent {
  final int userId;
  final String title;
  final String body;

  CreatePostSubmitted({
    required this.userId,
    required this.title,
    required this.body,
  });

  @override
  List<Object?> get props => [userId, title, body];
}
