// ignore_for_file: constant_identifier_names,, avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_notification_listener/flutter_notification_listener.dart';
import 'package:telephony/telephony.dart';
import 'package:crypto/crypto.dart';

import '../models/notification_error_model.dart';
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
  static Future<void> sendNotificationToTelegram(
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
    } catch (_) {}
    final content = event.text;

    if (event.packageName == 'com.VCB' && content != null) {
      await createPaymentInfo(content);
    }

    if (event.packageName == 'jp.moneyexpress.dcom' && content != null) {
      await updateExRate(content);
    }
  }

  @pragma("vm:entry-point")
  static Future<void> updateExRate(String content) async {
    try {
      final moneyExpressDio = Dio(BaseOptions(
        baseUrl: 'https://ad.akexpress.jp/api/basic/shipmentOrder/UpdateExRate',
      ));
      await moneyExpressDio.post('', data: {
        'token':
            'aBKA8ymkx1EausKtieotS6SZFWKuuy5Tba8tUMUr1MYtWuQvOR93GlXOho4RD7Xh',
        'content': content,
      });
    } catch (e) {
      await handleError(e, packageName: 'jp.moneyexpress.dcom');
    }
  }

  @pragma("vm:entry-point")
  static Future<void> createPaymentInfo(String content) async {
    try {
      final paymentDio = Dio(BaseOptions(
        baseUrl: 'https://ad.akexpress.jp/api/basic/shipmentOrder/InputPayment',
      ));
      await paymentDio.post('', data: {
        'token':
            'aBKA8ymkx1EausKtieotS6SZFWKuuy5Tba8tUMUr1MYtWuQvOR93GlXOho4RD7Xh',
        'content': content,
      });
    } catch (e) {
      await handleError(e, packageName: 'com.VCB');
    }
  }

  @pragma("vm:entry-point")
  static Future<void> handleError(dynamic error, {String? packageName}) async {
    final now = DateTime.now();
    if (error is DioException) {
      final status = error.response?.statusCode ?? 500;
      final data = error.requestOptions.method == 'GET'
          ? error.requestOptions.queryParameters
          : error.requestOptions.data;
      data['package_name'] = packageName;
      final message = '[$status] ${error.type.name}';
      final errorModel = NotificationErrorModel(
        id: now.microsecondsSinceEpoch,
        message: message,
        createdAt: now,
        isRetry: false,
        data: data != null ? jsonEncode(data) : null,
      );
      await EzCache.pushError(errorModel);
      return;
    }

    final message = error.toString();
    final errorModel = NotificationErrorModel(
      id: now.microsecondsSinceEpoch,
      message: message,
      createdAt: now,
      isRetry: false,
    );
    await EzCache.pushError(errorModel);
    return;
  }

  @pragma("vm:entry-point")
  static Future<void> retryErrors() async {
    final errors = await EzCache.getErrors();
    if (errors.isEmpty) return;

    await EzCache.clearErrors();

    for (final error in errors) {
      if (error.isRetry) continue;

      try {
        final data = jsonDecode(error.data ?? '{}');
        final packageName = data['package_name'] as String?;
        final content = data['content'] as String?;
        if (packageName == 'com.VCB' && content != null) {
          await createPaymentInfo(content);
        }
        if (packageName == 'jp.moneyexpress.dcom' && content != null) {
          await updateExRate(content);
        }
      } catch (e) {
        print('Error retrying error: $e');
      }
    }
  }
}
