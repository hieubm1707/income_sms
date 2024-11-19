import 'package:json_annotation/json_annotation.dart';

part 'notification_error_model.g.dart';

@JsonSerializable()
class NotificationErrorModel {
  NotificationErrorModel({
    required this.id,
    required this.message,
    required this.createdAt,
    required this.isRetry,
    this.data,
  });

  final int id;
  final String message;
  final DateTime createdAt;
  final bool isRetry;
  final String? data;

  factory NotificationErrorModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationErrorModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationErrorModelToJson(this);
}
