import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/item.dart';
import '../models/message.dart';

class ApiService {
  static const String baseUrl =  "https://csci410test.atwebpages.com";

  Future<User> register(String name, String email, String password) async {
    final url = '$baseUrl/register.php';
    final body = {
      'name': name,
      'email': email,
      'password': password,
    };

    print("🔄 Registering user...");
    print("📤 POST $url");
    print("📦 Body: ${jsonEncode(body)}");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print("✅ Status: ${response.statusCode}");
      print("📥 Response: ${response.body}");

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        return User.fromJson(data['user'] ?? {
          "id": 0,
          "name": name,
          "email": email,
        });
      } else {
        throw Exception(data['message'] ?? 'Failed to register');
      }
    } catch (e) {
      print("❌ Error during register: $e");
      rethrow;
    }
  }

  Future<User> login(String email, String password) async {
    final url = '$baseUrl/login.php';
    final body = {
      'email': email,
      'password': password,
    };

    print("🔄 Logging in...");
    print("📤 POST $url");
    print("📦 Body: ${jsonEncode(body)}");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print("✅ Status: ${response.statusCode}");
      print("📥 Response: ${response.body}");

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        return User.fromJson(data['user']);
      } else {
        throw Exception(data['message'] ?? 'Failed to login');
      }
    } catch (e) {
      print("❌ Error during login: $e");
      rethrow;
    }
  }

  Future<List<Item>> getItems({String? status, String? category}) async {
    final queryParams = <String, String>{};
    if (status != null) queryParams['status'] = status;
    if (category != null) queryParams['category'] = category;

    final uri = Uri.parse('$baseUrl/get_items.php').replace(queryParameters: queryParams);

    print("🔄 Fetching items...");
    print("📤 GET $uri");

    try {
      final response = await http.get(uri);

      print("✅ Status: ${response.statusCode}");
      print("📥 Response: ${response.body}");

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        return List<Item>.from(data['items'].map((item) => Item.fromJson(item)));
      } else {
        throw Exception(data['message'] ?? 'Failed to load items');
      }
    } catch (e) {
      print("❌ Error during getItems: $e");
      rethrow;
    }
  }

  Future<List<Item>> getUserItems(int userId) async {
    final url = '$baseUrl/get_user_items.php';
    final body = {'user_id': userId};

    print("🔄 Fetching user items...");
    print("📤 POST $url");
    print("📦 Body: ${jsonEncode(body)}");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print("✅ Status: ${response.statusCode}");
      print("📥 Response: ${response.body}");

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        return List<Item>.from(data['items'].map((item) => Item.fromJson(item)));
      } else {
        throw Exception(data['message'] ?? 'Failed to load user items');
      }
    } catch (e) {
      print("❌ Error during getUserItems: $e");
      rethrow;
    }
  }

  Future<void> addItem(Item item) async {
    final url = '$baseUrl/add_item.php';
    final body = item.toJson();

    print("🔄 Adding item...");
    print("📤 POST $url");
    print("📦 Body: ${jsonEncode(body)}");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print("✅ Status: ${response.statusCode}");
      print("📥 Response: ${response.body}");

      final data = jsonDecode(response.body);
      if (response.statusCode != 200 || data['success'] != true) {
        throw Exception(data['message'] ?? 'Failed to add item');
      }
    } catch (e) {
      print("❌ Error during addItem: $e");
      rethrow;
    }
  }

  Future<void> deleteItem(int itemId) async {
    final url = '$baseUrl/delete_item.php';
    final body = {'item_id': itemId};

    print("🔄 Deleting item...");
    print("📤 POST $url");
    print("📦 Body: ${jsonEncode(body)}");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print("✅ Status: ${response.statusCode}");
      print("📥 Response: ${response.body}");

      final data = jsonDecode(response.body);
      if (response.statusCode != 200 || data['success'] != true) {
        throw Exception(data['message'] ?? 'Failed to delete item');
      }
    } catch (e) {
      print("❌ Error during deleteItem: $e");
      rethrow;
    }
  }

  Future<List<Message>> getMessages(int itemId, int user1Id, int user2Id) async {
    final url = '$baseUrl/get_messages.php';
    final body = {
      'item_id': itemId,
      'user1_id': user1Id,
      'user2_id': user2Id,
    };

    print("🔄 Getting messages...");
    print("📤 POST $url");
    print("📦 Body: ${jsonEncode(body)}");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print("✅ Status: ${response.statusCode}");
      print("📥 Response: ${response.body}");

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        return List<Message>.from(data['messages'].map((m) => Message.fromJson(m)));
      } else {
        throw Exception(data['message'] ?? 'Failed to load messages');
      }
    } catch (e) {
      print("❌ Error during getMessages: $e");
      rethrow;
    }
  }

  Future<void> sendMessage(Message message) async {
    final url = '$baseUrl/send_message.php';
    final body = message.toJson();

    print("🔄 Sending message...");
    print("📤 POST $url");
    print("📦 Body: ${jsonEncode(body)}");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print("✅ Status: ${response.statusCode}");
      print("📥 Response: ${response.body}");

      final data = jsonDecode(response.body);
      if (response.statusCode != 200 || data['success'] != true) {
        throw Exception(data['message'] ?? 'Failed to send message');
      }
    } catch (e) {
      print("❌ Error during sendMessage: $e");
      rethrow;
    }
  }
}
