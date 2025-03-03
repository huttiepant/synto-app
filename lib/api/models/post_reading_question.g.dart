// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_reading_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostReadingQuestion _$PostReadingQuestionFromJson(Map<String, dynamic> json) =>
    PostReadingQuestion(
      id: (json['id'] as num).toInt(),
      type: json['type'] as String,
      question: json['question'] as String,
      info: json['info'] as String?,
      tips: json['tips'] as String?,
      dialog: json['dialog'] as String?,
      heading: json['heading'] as String?,
    );
