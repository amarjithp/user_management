import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_event.dart';
import 'user_state.dart';
import '../../../data/services/user_service.dart';
import '../../../data/models/user_model.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserService userService;
  static const int _limit = 10;
  int _skip = 0;
  String? _currentSearch;

  UserBloc({required this.userService}) : super(const UserState()) {
    on<FetchUsers>(_onFetchUsers);
    on<RefreshUsers>(_onRefreshUsers);
  }

  Future<void> _onFetchUsers(FetchUsers event, Emitter<UserState> emit) async {
    if (state.hasReachedMax && !event.isInitialLoad) return;

    if (event.isInitialLoad) {
      _skip = 0;
      _currentSearch = event.searchQuery;

      emit(state.copyWith(
        status: UserStatus.loading,
        users: [],
        allUsers: [],
        hasReachedMax: false,
        error: null,
      ));
    }

    try {
      // Fetch next batch of users
      final fetchedUsers = await userService.fetchUsers(limit: 100, skip: _skip);

      // Update skip for next pagination
      _skip += fetchedUsers.length;

      // Append new users to existing list
      final updatedAllUsers = event.isInitialLoad
          ? fetchedUsers
          : [...state.allUsers, ...fetchedUsers];

      // Local search filter
      final visibleUsers = (_currentSearch?.isNotEmpty ?? false)
          ? updatedAllUsers.where((user) =>
              user.firstName.toLowerCase().contains(_currentSearch!.toLowerCase()) ||
              user.lastName.toLowerCase().contains(_currentSearch!.toLowerCase()))
              .toList()
          : updatedAllUsers;

      emit(state.copyWith(
        status: UserStatus.success,
        users: visibleUsers,
        allUsers: updatedAllUsers,
        hasReachedMax: fetchedUsers.length < _limit,
        error: null,
      ));
      print('Fetched: ${fetchedUsers.length}');
print('Total in allUsers: ${updatedAllUsers.length}');
print('Visible after search: ${visibleUsers.length}');

    } catch (e) {
      emit(state.copyWith(
        status: UserStatus.failure,
        error: e.toString(),
      ));
    }
    
  }

  Future<void> _onRefreshUsers(RefreshUsers event, Emitter<UserState> emit) async {
    _skip = 0;
    try {
      final users = await userService.fetchUsers(limit: _limit);
      emit(state.copyWith(
        status: UserStatus.success,
        users: users,
        allUsers: users,
        hasReachedMax: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: UserStatus.failure,
        error: e.toString(),
      ));
    }
  }
}
