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
      // Try fetching from API
      final fetchedUsers = await userService.fetchUsers(limit: 100, skip: _skip);

      _skip += fetchedUsers.length;

      final updatedAllUsers = event.isInitialLoad
          ? fetchedUsers
          : [...state.allUsers, ...fetchedUsers];

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
    } catch (e) {
      // On error, try fetching from cache
      final cachedUsers = userService.getCachedUsers();

      if (cachedUsers.isNotEmpty) {
        final visibleUsers = (_currentSearch?.isNotEmpty ?? false)
            ? cachedUsers.where((user) =>
                user.firstName.toLowerCase().contains(_currentSearch!.toLowerCase()) ||
                user.lastName.toLowerCase().contains(_currentSearch!.toLowerCase()))
                .toList()
            : cachedUsers;

        emit(state.copyWith(
          status: UserStatus.success,
          users: visibleUsers,
          allUsers: cachedUsers,
          hasReachedMax: true, // no pagination on cached data
          error: 'Loaded cached data due to error: $e',
        ));
      } else {
        // No cached data, emit failure
        emit(state.copyWith(
          status: UserStatus.failure,
          error: e.toString(),
        ));
      }
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
