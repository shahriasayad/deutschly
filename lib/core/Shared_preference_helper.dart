// ignore_for_file: file_names

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  const SharedPreferenceHelper._();

  static SharedPreferences? _preferences;

  static Future<void> init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  static Future<bool> setString(String key, String value) async {
    final prefs = _preferences ?? await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }

  static String? getString(String key) {
    return _preferences?.getString(key);
  }

  static Future<bool> setStringList(String key, List<String> value) async {
    final prefs = _preferences ?? await SharedPreferences.getInstance();
    return prefs.setStringList(key, value);
  }

  static List<String> getStringList(String key) {
    return _preferences?.getStringList(key) ?? <String>[];
  }

  static Future<bool> clear() async {
    final prefs = _preferences ?? await SharedPreferences.getInstance();
    return prefs.clear();
  }
}
