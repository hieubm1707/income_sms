// ignore_for_file: constant_identifier_names,, avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_notification_listener/flutter_notification_listener.dart';
import 'package:telephony/telephony.dart';
import 'package:crypto/crypto.dart';

import 'ez_cache.dart';

@pragma("vm:entry-point")
class TelegramBotHelper {
  @pragma("vm:entry-point")
  static Future<void> sendMessage(SmsMessage smsMessage) async {
    try {
      final chatId = await EzCache.getChatId();
      final apiKey = await EzCache.getApiToken();
      final chatUrl = await getChatUrl(apiKey);
      if (chatId.isEmpty || chatUrl.isEmpty) {
        return;
      }

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
      final chatId = await EzCache.getChatId();
      final apiKey = await EzCache.getApiToken();
      final chatUrl = await getChatUrl(apiKey);
      if (chatId.isEmpty || chatUrl.isEmpty) {
        return;
      }

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
  static Future<String> getChatUrl(String apiKey) async {
    try {
      return 'https://api.telegram.org/bot$apiKey/sendMessage';
    } catch (error) {
      print('Error getting chat id: $error');
    }
    return '';
  }

  @pragma("vm:entry-point")
  static Future<void> sendNotificationMessage(
    NotificationEvent event,
  ) async {
    try {
      final text =
          '${event.packageName ?? ''}-${event.title ?? ''}-${event.text ?? ''}';
      final hashData = sha256.convert(utf8.encode(text)).toString();
      final existData = await EzCache.checkExistInNotificationList(hashData);
      if (existData) return;

      final chatId = await EzCache.getChatId();
      final apiKey = await EzCache.getApiToken();
      final chatUrl = await getChatUrl(apiKey);
      if (chatId.isEmpty || chatUrl.isEmpty) {
        return;
      }

      final message = """
[SMS MESSAGE NOTIFICATION]
PACKAGE NAME: ${event.packageName}
DATE: ${event.createAt}
TITLE: ${event.title}
CONTENT: ${event.text}
""";
      print('message: $message');

      final dio = Dio(BaseOptions(baseUrl: chatUrl));
      await dio.get('', queryParameters: {
        'chat_id': chatId,
        'text': message,
      });

      if (event.packageName == 'com.VCB') {
        final paymentDio = Dio(BaseOptions(
          baseUrl: 'https://ad.express/api/basic/shipmentOrder/InputPayment',
        ));
        await paymentDio.post('', data: {
          'token':
              'aBKA8ymkx1EausKtieotS6SZFWKuuy5Tba8tUMUr1MYtWuQvOR93GlXOho4RD7Xh',
          'content': event.text,
        });
      }
    } catch (e, stackTrace) {
      print('Error sending message to telegram: $e');
      print(stackTrace);
    }
  }
}
