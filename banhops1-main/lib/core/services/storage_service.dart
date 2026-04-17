import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  Future<void> saveLang(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("lang", lang);
  }

  Future<String?> getLang() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("lang");
  }
}
