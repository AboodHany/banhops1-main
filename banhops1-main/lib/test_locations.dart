import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final url = 'https://ujursejrleqjlrfgksfh.supabase.co/rest/v1/locations';
  final anonKey = 'sb_publishable_7dbspU0EF5Ekj-B-agyN1g_LCO8_4Ux';
  
  final headers = {
    'apikey': anonKey,
    'Authorization': 'Bearer $anonKey',
    'Content-Type': 'application/json',
    'Prefer': 'resolution=merge-duplicates,return=representation',
  };

  try {
    print("Attempting to upsert location 201...");
    final body = json.encode({
      'id': 201,
      'name': 'Ahmed Helmy', // Restore original name
      'coordinates': '(31.2467, 30.0631)',
      'type': 'Hub',
    });
    final res = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );
    print("UPSERT Status: ${res.statusCode}");
    print("UPSERT Response: ${res.body}");
  } catch (e) {
    print("Exception: $e");
  }
}
