import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatPersistenceService {
  static const String _baseUrl =
      'https://banhops-backend-production.up.railway.app';

  static Future<void> saveMessage({
    required String username,
    required String message,
    required bool isUser,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/api/chat');

      await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "message": message,
          "isUser": isUser,
        }),
      ).timeout(const Duration(seconds: 5));
    } catch (e) {
      print('Error saving message in ChatPersistenceService: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getMessages(
      String username) async {
    try {
      final url = Uri.parse('$_baseUrl/api/chat/$username');

      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      }
    } catch (e) {
      print('Error getting messages in ChatPersistenceService: $e');
    }
    return [];
  }

  static Future<void> clearChat(String username) async {
    try {
      final url = Uri.parse('$_baseUrl/api/chat/$username');
      await http.delete(url).timeout(const Duration(seconds: 5));
    } catch (e) {
      print('Error clearing chat in ChatPersistenceService: $e');
    }
  }
}
