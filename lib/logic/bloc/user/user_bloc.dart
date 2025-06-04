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
    if (event.isInitialLoad) {
      emit(state.copyWith(status: UserStatus.loading));
      _skip = 0;
      _currentSearch = event.searchQuery;
    }

    try {
      final users = await userService.fetchUsers(
        limit: _limit,
        skip: _skip,
        search: _currentSearch,
      );

      if (users.isEmpty) {
        emit(state.copyWith(
          status: UserStatus.success,
          hasReachedMax: true,
        ));
      } else {
        _skip += _limit;
        emit(state.copyWith(
          status: UserStatus.success,
          users: [...state.users, ...users],
          hasReachedMax: false,
        ));
      }
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
