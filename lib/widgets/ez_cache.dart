// ignore_for_file: avoid_print

import '../bootstrap.dart';
import 'constant.dart';
import 'tele_default_values.dart';

class EzCache {
  static final EzCache _instance = EzCache._internal();
  factory EzCache() => _instance;
  EzCache._internal();

  @pragma("vm:entry-point")
  Future<void> set(String key, dynamic value) async {
    final prefs = await preferences;
    prefs.setString(key, value);
  }

  @pragma("vm:entry-point")
  Future<dynamic> get(String key) async {
    final prefs = await preferences;
    return prefs.getString(key);
  }

  @pragma("vm:entry-point")
  Future<void> remove(String key) async {
    final prefs = await preferences;
    prefs.remove(key);
  }

  @pragma("vm:entry-point")
  static Future<String> getApiToken() async {
    try {
      final prefs = await preferences;
      var apiKey = prefs.getString(teleApiKey);
      if (apiKey == null) {
        apiKey = TelegramDefaultValue.instance.getApiToken();
        prefs.setString(teleApiKey, apiKey);
        return apiKey;
      }
      return apiKey;
    } catch (error) {
      print('Error getting chat id: $error');
    }
    return '';
  }

  static Future<void> setApiToken(String value) {
    return _instance.set(teleApiKey, value);
  }

  @pragma("vm:entry-point")
  static Future<String> getChatId() async {
    try {
      final prefs = await preferences;
      var chatId = prefs.getString(teleChatId);
      if (chatId == null) {
        chatId = TelegramDefaultValue.instance.getChatId();
        prefs.setString(teleChatId, chatId);
        return chatId;
      }
      return chatId;
    } catch (error) {
      print('Error setting chat id: $error');
    }
    return '';
  }

  static Future<void> setChatId(String value) {
    return _instance.set(teleChatId, value);
  }
}
