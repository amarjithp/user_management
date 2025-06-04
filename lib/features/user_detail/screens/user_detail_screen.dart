import 'package:flutter/material.dart';
import '../../../data/models/user_model.dart';
import 'create_post_screen.dart';
import '../bloc/user_detail_bloc.dart';
import '../bloc/user_detail_event.dart';
import '../bloc/user_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/user_info_card.dart';
import '../widgets/post_list.dart';
import '../widgets/todo_list.dart';
import '../../../data/services/post_service.dart'; // Import the post service

class UserDetailScreen extends StatelessWidget {
  final User user;

  const UserDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserDetailBloc()..add(LoadUserDetail(user.id)),
      child: Scaffold(
        appBar: AppBar(title: Text('${user.firstName} ${user.lastName}')),
        body: BlocBuilder<UserDetailBloc, UserDetailState>(
          builder: (context, state) {
            if (state.status == DetailStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.status == DetailStatus.failure) {
              return Center(child: Text('Error: ${state.error}'));
            } else {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserInfoCard(user: user),
                    const SizedBox(height: 16),
                    Text('Posts',
                        style: Theme.of(context).textTheme.titleLarge),
                    PostList(posts: state.posts),
                    const SizedBox(height: 16),
                    Text('Todos',
                        style: Theme.of(context).textTheme.titleLarge),
                    TodoList(todos: state.todos),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        // Navigate to Create Post screen
                        final newPost = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CreatePostScreen(userId: user.id),
                          ),
                        );

                        // If a post is created, add it to the existing posts
                        if (newPost != null) {
                          context
                              .read<UserDetailBloc>()
                              .add(AddNewPost(newPost));
                        }
                      },
                      child: Text('Create Post'),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
