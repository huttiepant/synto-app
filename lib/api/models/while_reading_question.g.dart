// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'while_reading_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WhileReadingQuestion _$WhileReadingQuestionFromJson(
        Map<String, dynamic> json) =>
    WhileReadingQuestion(
      id: (json['id'] as num).toInt(),
      type: json['type'] as String,
      question: json['question'] as String,
      answers: (json['answers'] as List<dynamic>?)
          ?.map((e) => Answer.fromJson(e as Map<String, dynamic>))
          .toList(),
      info: json['info'] as String?,
      tips: json['tips'] as String?,
      dialog: json['dialog'] as String?,
    );
