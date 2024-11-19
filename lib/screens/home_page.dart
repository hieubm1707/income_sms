// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import '../widgets/ez_button.dart';
import '../widgets/ez_cache.dart';
import '../widgets/ez_input.dart';
import '../widgets/tele_bot.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          InkWell(
            onTap: () => TelegramBotHelper.sendTestMessage(),
            child: const Text(
              'Welcome!',
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
