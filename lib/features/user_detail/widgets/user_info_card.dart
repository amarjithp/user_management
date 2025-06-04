import 'package:flutter/material.dart';
import '../../../data/models/user_model.dart';

class UserInfoCard extends StatelessWidget {
  final User user;
  const UserInfoCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(backgroundImage: NetworkImage(user.image)),
        title: Text('${user.firstName} ${user.lastName}'),
        subtitle: Text(user.email),
      ),
    );
  }
}
