import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Store {
  static Future<void> saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static Future<void> saveMap(String key, Map<String, dynamic> value) async {
    saveString(key, json.encode(value));
  }

  static Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<bool> removeString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

  static Future<Map<String, dynamic>> getMap(String key) async {
    try {
      Map<String, dynamic> map = json.decode(await getString(key) ?? "");
      return map;
    } on Exception catch (e) {
      return {};
    }
  }
}
