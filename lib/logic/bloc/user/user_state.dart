import 'package:equatable/equatable.dart';
import '../../../data/models/user_model.dart';

enum UserStatus { initial, loading, success, failure }

class UserState extends Equatable {
  final List<User> users;
  final List<User> allUsers; // 🆕 new field to store all fetched users
  final bool hasReachedMax;
  final UserStatus status;
  final String? error;

  const UserState({
    this.users = const [],
    this.allUsers = const [],
    this.hasReachedMax = false,
    this.status = UserStatus.initial,
    this.error,
  });

  UserState copyWith({
    List<User>? users,
    List<User>? allUsers,
    bool? hasReachedMax,
    UserStatus? status,
    String? error,
  }) {
    return UserState(
      users: users ?? this.users,
      allUsers: allUsers ?? this.allUsers,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
      error: error,
    );
  }

  @override
  List<Object?> get props => [users, allUsers, hasReachedMax, status, error];
}

