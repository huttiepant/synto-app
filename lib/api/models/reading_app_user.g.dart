// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReadingAppUser _$ReadingAppUserFromJson(Map<String, dynamic> json) =>
    ReadingAppUser(
      (json['user_id'] as num).toInt(),
      json['access_token'] as String,
      json['token_type'] as String,
      json['expires_in'] as String,
      json['refresh_token'] as String,
      json['id'] as String,
      (json['createdAt'] as num).toInt(),
      (json['updatedAt'] as num).toInt(),
      json['firebaseUid'] as String,
      json['tunedGlobalExternalId'] as String,
      json['countryCode'] as String,
    );
