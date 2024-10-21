//Handle background message
import 'package:flutter/material.dart';
// import 'package:income_sms/widgets/ez_button.dart';
// import 'package:income_sms/widgets/ez_input.dart';
// import 'package:income_sms/widgets/tele_bot.dart';

import 'widgets/ez_button.dart';
import 'widgets/ez_cache.dart';
import 'widgets/ez_input.dart';
import 'widgets/tele_bot.dart';

@pragma("vm:entry-point")
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Income Sms',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AppView(title: 'Income Sms'),
    );
  }
}

@pragma("vm:entry-point")
class AppView extends StatefulWidget {
  const AppView({super.key, required this.title});

  final String title;

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _formKey = GlobalKey<FormState>();
  final _apiTokenController = TextEditingController();
  final _chatIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async {
    final apiToken = await EzCache.getApiToken();
    final chatId = await EzCache.getChatId();

    _apiTokenController.text = apiToken;
    _chatIdController.text = chatId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            InkWell(
              onTap: () => TelegramBotHelper.sendTestMessage(),
              child: const Text(
                'Hello!',
                style: TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(height: 20),
            EzInput(
              label: 'Telegram Bot API Token',
              labelStyle: Theme.of(context).textTheme.bodyLarge,
              hintText: 'Enter your telegram bot api token',
              controller: _apiTokenController,
              margin: const EdgeInsets.only(top: 12),
              validator: (text) {
                final value = text ?? '';
                if (value.isEmpty) {
                  return 'Please enter your telegram bot api token';
                }
                return null;
              },
            ),
            EzInput(
              label: 'Telegram Chat ID',
              labelStyle: Theme.of(context).textTheme.bodyLarge,
              hintText: 'Enter your telegram chat id',
              controller: _chatIdController,
              margin: const EdgeInsets.only(top: 12),
              validator: (text) {
                final value = text ?? '';
                if (value.isEmpty) {
                  return 'Please enter your telegram chat id';
                }
                return null;
              },
            ),
            Row(
              children: [
                Expanded(
                  child: EzButton(
                    onPressed: onClear,
                    title: 'Clear',
                    buttonType: EzButtonType.outline,
                  ),
                ),
                Expanded(
                  child: EzButton(
                    onPressed: onPressed,
                    title: 'Save',
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void onPressed() async {
    if (_formKey.currentState!.validate()) {
      await EzCache.setApiToken(_apiTokenController.text);
      await EzCache.setChatId(_chatIdController.text);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Saved successfully!"),
      ));
    }
  }

  void onClear() async {
    _apiTokenController.clear();
    _chatIdController.clear();

    await EzCache.setApiToken(_apiTokenController.text);
    await EzCache.setChatId(_chatIdController.text);
  }
}
