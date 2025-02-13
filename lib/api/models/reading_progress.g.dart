// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReadingProgress _$ReadingProgressFromJson(Map<String, dynamic> json) =>
    ReadingProgress(
      currentQuestionIndices: (json['currentQuestionIndices'] as num).toInt(),
      answeredQuestions:
          (json['answeredQuestions'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(int.parse(k), e),
      ),
    );

Map<String, dynamic> _$ReadingProgressToJson(ReadingProgress instance) =>
    <String, dynamic>{
      'currentQuestionIndices': instance.currentQuestionIndices,
      'answeredQuestions':
          instance.answeredQuestions.map((k, e) => MapEntry(k.toString(), e)),
    };
