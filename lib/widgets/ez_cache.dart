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
      final apiKey = prefs.getString(teleApiKey);
      if (apiKey == null) {
        return TelegramDefaultValue.instance.getChatUrl();
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
      final chatId = prefs.getString(teleChatId);
      if (chatId == null) {
        return TelegramDefaultValue.instance.getChatId();
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
