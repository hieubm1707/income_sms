import 'package:flutter/material.dart';

import '../models/notification_error_model.dart';
import '../widgets/ez_cache.dart';
import '../widgets/tele_bot.dart';

class ErrorPage extends StatefulWidget {
  const ErrorPage({super.key});

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  var errors = <NotificationErrorModel>[];

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async {
    errors = await EzCache.getErrors();
    setState(() {});
  }

  void retryErrors() async {
    await TelegramBotHelper.retryErrors();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        initData();
      },
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 20),
              const Text(
                'Errors',
                style: TextStyle(fontSize: 24),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: retryErrors,
              ),
              const SizedBox(width: 20),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: errors.length,
              itemBuilder: (context, index) {
                return _buildErrorItem(errors[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorItem(final NotificationErrorModel error) {
    return ListTile(
      title: Row(
        children: [
          Expanded(child: Text(error.message)),
          Text(formatDateTime(error.createdAt))
        ],
      ),
      subtitle: Text(error.data.toString()),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: () async {
          errors.remove(error);
          await EzCache.updateErrors(errors);
          setState(() {});
        },
      ),
    );
  }

  String formatDateTime(DateTime dateTime) {
    return '${dateTime.hour}:${dateTime.minute} ${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}
