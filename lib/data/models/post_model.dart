class Post {
  final int id;
  final int userId;    // Add this field
  final String title;
  final String body;

  Post({
    required this.id,
    required this.userId,   // Add to constructor
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json['id'],
        userId: json['userId'],   // Parse userId from JSON
        title: json['title'],
        body: json['body'],
      );
}
