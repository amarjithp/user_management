import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
  @override
  List<Object?> get props => [];
}

class FetchUsers extends UserEvent {
  final bool isInitialLoad;
  final String? searchQuery;

  const FetchUsers({this.isInitialLoad = false, this.searchQuery});
}

class RefreshUsers extends UserEvent {}
