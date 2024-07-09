import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/Account.dart';

class PrefUtil {
  static late final SharedPreferences preferences;
  static bool _init = false;
  static Future init() async {
    if (_init) return;
    preferences = await SharedPreferences.getInstance();
    _init = true;
    return preferences;
  }

  static setValue(String key, Object value) {
    switch (value.runtimeType) {
      case String:
        preferences.setString(key, value as String);
        break;
      case bool:
        preferences.setBool(key, value as bool);
        break;
      case int:
        preferences.setInt(key, value as int);
        break;
      default:
    }
  }

  static Object getValue(String key, Object defaultValue) {
    switch (defaultValue.runtimeType) {
      case String:
        return preferences.getString(key) ?? "";
      case bool:
        return preferences.getBool(key) ?? false;
      case int:
        return preferences.getInt(key) ?? 0;
      default:
        return defaultValue;
    }
  }

  static Account? getCurrentUser() {
    final jsonStr = preferences.getString('account');
    if (jsonStr == null) return null;

    final Map<String, dynamic> json = jsonDecode(jsonStr);
    return Account.fromJson(json);
  }
}
