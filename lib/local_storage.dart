import 'package:shared_preferences/shared_preferences.dart';

/// Системд ашиглагдах [Local Storage]-тэй харьцах сервис
class LocalStorage {
  /// Өгөгдсөн [key] түлхүүрийн дагуу, өгөгдсөн [value] утгыг хадгалах
  static Future<void> saveItem(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  /// Өгөгдсөн [key] түлхүүрийн дагуу хадгалагдсан утгыг авах
  /// Хэрэв байхгүй бол [defaultValue] буцаана
  static Future<String> getItem(String key, String defaultValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? defaultValue;
  }

  /// Өгөгдсөн [key] түлхүүрийн дагуу утгыг цэвэрлэх
  static Future<bool> clearItem(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove(key);
  }
}
