import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/bloc/user/user_bloc.dart';
import '../../logic/bloc/user/user_event.dart';
import '../../logic/bloc/user/user_state.dart';
import '../widgets/user_tile.dart';
import '../../logic/cubit/theme_cubit.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(const FetchUsers(isInitialLoad: true));
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 300 &&
        !context.read<UserBloc>().state.hasReachedMax) {
      context.read<UserBloc>().add(const FetchUsers());
    }
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      final query = _searchController.text.trim();
      context.read<UserBloc>().add(FetchUsers(
        isInitialLoad: true,
        searchQuery: query.isEmpty ? null : query,
      ));
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
        actions: [
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              final isDark = themeMode == ThemeMode.dark;
              return IconButton(
                icon: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
                onPressed: () {
                  context.read<ThemeCubit>().toggleTheme(!isDark);
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search by name...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state.status == UserStatus.loading && state.users.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.status == UserStatus.failure) {
                  return Center(child: Text("Error: ${state.error}"));
                }

                if (state.users.isEmpty) {
                  return const Center(child: Text("No users found."));
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<UserBloc>().add(const FetchUsers(isInitialLoad: true));
                  },
                  child: ListView.builder(
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
                  ),
                );
              },
            ),
          ),

        ],
      ),
    );
  }
}
