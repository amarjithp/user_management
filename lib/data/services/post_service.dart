import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';

class PostService {
  final List<Post> _localPosts = []; // Local cache for created posts

  Future<List<Post>> fetchPostsByUser(int userId) async {
    final url = Uri.parse('https://dummyjson.com/posts/user/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Combine API posts with local posts for the user
      final apiPosts = (data['posts'] as List).map((e) => Post.fromJson(e)).toList();

      // Return combined list (API + local)
      final combinedPosts = List<Post>.from(apiPosts)
        ..addAll(_localPosts.where((post) => post.userId == userId));
      return combinedPosts;
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<Post> createPostLocally({
    required int userId,
    required String title,
    required String body,
  }) async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 2));

    // Simulate occasional failure
    if (DateTime.now().millisecondsSinceEpoch % 5 == 0) {
      throw Exception("Failed to create post due to network error.");
    }

    // Generate a new local ID (max existing + 1 or 1 if empty)
    final newId = _localPosts.isNotEmpty
        ? _localPosts.map((post) => post.id).reduce((a, b) => a > b ? a : b) + 1
        : 1;

    final newPost = Post(id: newId, userId: userId, title: title, body: body);

    _localPosts.add(newPost);

    return newPost;
  }
}
