import '../../../data/models/post_model.dart';

abstract class UserDetailEvent {}

class LoadUserDetail extends UserDetailEvent {
  final int userId;
  LoadUserDetail(this.userId);
}

class AddNewPost extends UserDetailEvent {
  final Post newPost;
  AddNewPost(this.newPost);
}
