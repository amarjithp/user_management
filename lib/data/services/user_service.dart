import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import '../models/user_model.dart';
import '../../core/utils/api_constants.dart';

class UserService {
  late Box<User> _userBox;

  // Initialize and open Hive box
  Future<void> init() async {
    _userBox = await Hive.openBox<User>('usersBox');
  }

  Future<List<User>> fetchUsers({int limit = 10, int skip = 0, String? search}) async {
    String url = '${ApiConstants.users}?limit=$limit&skip=$skip';
    if (search != null && search.isNotEmpty) {
      url += '&q=$search';
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final users = (data['users'] as List).map((u) => User.fromJson(u)).toList();

      // Clear old cached users and save new users to Hive
      await _userBox.clear();
      for (var user in users) {
        await _userBox.put(user.id, user);
      }

      return users;
    } else {
      throw Exception('Failed to load users');
    }
  }

  // Get cached users from Hive (for offline or fallback)
  List<User> getCachedUsers() {
    return _userBox.values.toList();
  }
}
