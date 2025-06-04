abstract class UserDetailEvent {}

class LoadUserDetail extends UserDetailEvent {
  final int userId;
  LoadUserDetail(this.userId);
}
