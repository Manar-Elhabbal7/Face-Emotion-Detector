import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setStatus(String key, bool value) async {
    await _prefs.setBool(key,value);
  }

  static bool getStatus(String key) {
    return _prefs.getBool(key) ?? false;
  }
  
}
