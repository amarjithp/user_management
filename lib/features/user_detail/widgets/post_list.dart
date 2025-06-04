import 'package:flutter/material.dart';
import '../../../data/models/post_model.dart';

class PostList extends StatelessWidget {
  final List<Post> posts;
  const PostList({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: posts.map((p) => ListTile(
        title: Text(p.title),
        subtitle: Text(p.body),
      )).toList(),
    );
  }
}
