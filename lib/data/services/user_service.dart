import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../../core/utils/api_constants.dart';

class UserService {
  Future<List<User>> fetchUsers({int limit = 10, int skip = 0, String? search}) async {
    final query = search != null ? '&q=$search' : '';
    final url = Uri.parse('${ApiConstants.users}?limit=$limit&skip=$skip$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final users = (data['users'] as List)
          .map((u) => User.fromJson(u))
          .toList();
      return users;
    } else {
      throw Exception('Failed to load users');
    }
  }
}
