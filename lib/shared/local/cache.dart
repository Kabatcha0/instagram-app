import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences sharedPreferences;
  static Future<SharedPreferences> init() async {
    return sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> setString(
      {required String key, required String value}) async {
    log("message");
    return await sharedPreferences.setString(key, value);
  }

  static getString({required String key}) {
    return sharedPreferences.getString(key);
  }

  static Future<bool> removeString({required String key}) async {
    return await sharedPreferences.remove(key);
  }
}
