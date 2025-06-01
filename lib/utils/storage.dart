/*import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class Storage {
  static const String _userKey = 'user';

  

  static Future<User?> getUser() async {
    // TEMPORARY: return a test user manually
    return User(id: 2, name: 'Ali Test', email: 'ali@test.com');
  }

  static Future<bool> isLoggedIn() async {
    return true; // Pretend user is logged in
  }

  static Future<void> clearUser() async {}
  static Future<void> saveUser(User user) async {}
}*/

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class Storage {
  static const String _userKey = 'user';

  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson == null) return null;
    return User.fromJson(jsonDecode(userJson));
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  static Future<bool> isLoggedIn() async {
    final user = await getUser();
    return user != null;
  }
} 
