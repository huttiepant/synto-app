// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionProgress _$QuestionProgressFromJson(Map<String, dynamic> json) =>
    QuestionProgress(
      preReading:
          ReadingProgress.fromJson(json['preReading'] as Map<String, dynamic>),
      whileReading: ReadingProgress.fromJson(
          json['whileReading'] as Map<String, dynamic>),
      postReading:
          ReadingProgress.fromJson(json['postReading'] as Map<String, dynamic>),
      readingStep: $enumDecode(_$ReadingStepEnumMap, json['readingStep']),
    );

Map<String, dynamic> _$QuestionProgressToJson(QuestionProgress instance) =>
    <String, dynamic>{
      'preReading': instance.preReading,
      'whileReading': instance.whileReading,
      'postReading': instance.postReading,
      'readingStep': _$ReadingStepEnumMap[instance.readingStep]!,
    };

const _$ReadingStepEnumMap = {
  ReadingStep.preReading: 'preReading',
  ReadingStep.whileReading: 'whileReading',
  ReadingStep.postReading: 'postReading',
};
