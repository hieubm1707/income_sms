// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_error_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationErrorModel _$NotificationErrorModelFromJson(
        Map<String, dynamic> json) =>
    NotificationErrorModel(
      id: (json['id'] as num).toInt(),
      message: json['message'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isRetry: json['isRetry'] as bool,
      data: json['data'] as String?,
    );

Map<String, dynamic> _$NotificationErrorModelToJson(
        NotificationErrorModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'message': instance.message,
      'createdAt': instance.createdAt.toIso8601String(),
      'isRetry': instance.isRetry,
      'data': instance.data,
    };
