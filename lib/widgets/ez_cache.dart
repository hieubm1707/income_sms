// ignore_for_file: avoid_print

import 'dart:convert';

import '../bootstrap.dart';
import '../models/notification_error_model.dart';
import 'constant.dart';
import 'tele_default_values.dart';

class EzCache {
  static final EzCache _instance = EzCache._internal();
  factory EzCache() => _instance;
  EzCache._internal();

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

  static Future<bool> setApiToken(String value) async {
    final prefs = await preferences;
    return prefs.setString(teleApiKey, value);
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

  static Future<bool> setChatId(String value) async {
    final prefs = await preferences;
    return prefs.setString(teleChatId, value);
  }

  @pragma("vm:entry-point")
  static Future<List<String>> getPushedNotificationList() async {
    try {
      final prefs = await preferences;
      return prefs.getStringList(teleContentNotifications) ?? [];
    } catch (error) {
      print('Error getting chat id: $error');
    }
    return [];
  }

  @pragma("vm:entry-point")
  static Future<bool> setPushedNotificationList(List<String> value) async {
    final prefs = await preferences;
    return prefs.setStringList(teleContentNotifications, value);
  }

  @pragma("vm:entry-point")
  static Future<bool> clearPushedNotificationList() async {
    final prefs = await preferences;
    return prefs.remove(teleContentNotifications);
  }

  @pragma("vm:entry-point")
  static Future<bool> checkExistInNotificationList(String value) async {
    final list = await getPushedNotificationList();
    final exist = list.contains(value);
    if (!exist) {
      list.add(value);
      await setPushedNotificationList(list);
    }
    if (list.length >= 10000) {
      list.removeRange(0, 5000);
      await setPushedNotificationList(list);
    }
    return exist;
  }

  @pragma("vm:entry-point")
  static Future<List<NotificationErrorModel>> getErrors() async {
    try {
      final prefs = await preferences;
      final errors = prefs.getStringList(notificationErrors) ?? [];
      return errors.map((e) {
        final json = jsonDecode(e);
        return NotificationErrorModel.fromJson(json);
      }).toList();
    } catch (error) {
      print('Error getting chat id: $error');
    }
    return [];
  }

  @pragma("vm:entry-point")
  static Future<bool> pushError(NotificationErrorModel error) async {
    final prefs = await preferences;
    final listData = prefs.getStringList(notificationErrors) ?? [];
    listData.add(jsonEncode(error.toJson()));
    return prefs.setStringList(notificationErrors, listData);
  }

  @pragma("vm:entry-point")
  static Future<void> updateErrors(List<NotificationErrorModel> errors) async {
    try {
      final prefs = await preferences;
      final listData = errors.map((e) => jsonEncode(e.toJson())).toList();
      await prefs.setStringList(notificationErrors, listData);
    } catch (_) {}
  }

  @pragma("vm:entry-point")
  static Future<bool> clearErrors() async {
    final prefs = await preferences;
    return prefs.remove(notificationErrors);
  }
}
