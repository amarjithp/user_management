import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/bloc/user/user_bloc.dart';
import '../../logic/bloc/user/user_event.dart';
import '../../logic/bloc/user/user_state.dart';
import '../widgets/user_tile.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(const FetchUsers(isInitialLoad: true));
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 300 &&
        !context.read<UserBloc>().state.hasReachedMax) {
      context.read<UserBloc>().add(const FetchUsers());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Users")),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state.status == UserStatus.loading && state.users.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == UserStatus.failure) {
            return Center(child: Text("Error: ${state.error}"));
          }

          return ListView.builder(
            controller: _scrollController,
            itemCount: state.hasReachedMax
                ? state.users.length
                : state.users.length + 1,
            itemBuilder: (context, index) {
              if (index >= state.users.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              return UserTile(user: state.users[index]);
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
