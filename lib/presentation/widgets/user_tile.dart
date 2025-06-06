import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../features/user_detail/screens/user_detail_screen.dart';

class UserTile extends StatelessWidget {
  final User user;

  const UserTile({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(user.image),
      ),
      title: Text(user.fullName),
      subtitle: Text(user.email),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => UserDetailScreen(user: user),
          ),
        );
      },

    );
  }
}
