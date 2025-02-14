import 'package:json_annotation/json_annotation.dart';

part 'while_reading_question.g.dart';

@JsonSerializable(createToJson: false)
class WhileReadingQuestion {
  final int id;
  final String? info;
  final String? tips;

  WhileReadingQuestion({
    required this.id,
    required this.info,
    required this.tips,
  });

  factory WhileReadingQuestion.fromJson(Map<String, dynamic> json) =>
      _$WhileReadingQuestionFromJson(json);
}
