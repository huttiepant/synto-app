import 'package:json_annotation/json_annotation.dart';

import 'answer.dart';

part 'while_reading_question.g.dart';

@JsonSerializable(createToJson: false)
class WhileReadingQuestion {
  final int id;
  final String type;
  final String question;
  final List<Answer>? answers;
  final String? info;
  final String? tips;
  final String? dialog;

  WhileReadingQuestion({
    required this.id,
    required this.type,
    required this.question,
    required this.answers,
    this.info,
    this.tips,
    this.dialog,
  });

  factory WhileReadingQuestion.fromJson(Map<String, dynamic> json) =>
      _$WhileReadingQuestionFromJson(json);
}
