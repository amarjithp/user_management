import 'package:equatable/equatable.dart';
import '../../../data/models/user_model.dart';

enum UserStatus { initial, loading, success, failure }

class UserState extends Equatable {
  final UserStatus status;
  final List<User> users;
  final bool hasReachedMax;
  final String? error;

  const UserState({
    this.status = UserStatus.initial,
    this.users = const [],
    this.hasReachedMax = false,
    this.error,
  });

  UserState copyWith({
    UserStatus? status,
    List<User>? users,
    bool? hasReachedMax,
    String? error,
  }) {
    return UserState(
      status: status ?? this.status,
      users: users ?? this.users,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, users, hasReachedMax, error];
}
