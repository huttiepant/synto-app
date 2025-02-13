// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProgress _$UserProgressFromJson(Map<String, dynamic> json) => UserProgress(
      progress: (json['progress'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            int.parse(k), QuestionProgress.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$UserProgressToJson(UserProgress instance) =>
    <String, dynamic>{
      'progress': instance.progress.map((k, e) => MapEntry(k.toString(), e)),
    };
