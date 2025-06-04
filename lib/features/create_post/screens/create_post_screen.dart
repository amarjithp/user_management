// lib/features/create_post/screens/create_post_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/create_post_bloc.dart';
import '../bloc/create_post_event.dart';
import '../bloc/create_post_state.dart';
import '../../../data/services/post_service.dart';

class CreatePostScreen extends StatefulWidget {
  final int userId;  // Pass the userId to associate the post

  const CreatePostScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final title = _titleController.text.trim();
      final body = _bodyController.text.trim();

      context.read<CreatePostBloc>().add(
            CreatePostSubmitted(
              userId: widget.userId,
              title: title,
              body: body,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreatePostBloc(postService: PostService()),
      child: Scaffold(
        appBar: AppBar(title: Text('Create Post')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<CreatePostBloc, CreatePostState>(
            listener: (context, state) {
              if (state is CreatePostSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Post created successfully!')),
                );
                Navigator.pop(context, state.post);
              } else if (state is CreatePostFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error)),
                );
              }
            },
            builder: (context, state) {
              if (state is CreatePostLoading) {
                return Center(child: CircularProgressIndicator());
              }
              return Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(labelText: 'Title'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Title is required' : null,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _bodyController,
                      decoration: InputDecoration(labelText: 'Body'),
                      maxLines: 5,
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Body is required' : null,
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _submit,
                      child: Text('Create Post'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
