import 'package:json_annotation/json_annotation.dart';
import 'package:synto_app/api/models/answer.dart';

part 'pre_reading_question.g.dart';

@JsonSerializable(createToJson: false)
class PreReadingQuestion {
  final int id;
  final String type;
  final String question;
  final List<Answer>? answers;
  final String? info;
  final String? tips;
  final String? dialog;

  PreReadingQuestion({
    required this.id,
    required this.type,
    required this.question,
    required this.answers,
    this.info,
    this.tips,
    this.dialog,
  });

  factory PreReadingQuestion.fromJson(Map<String, dynamic> json) =>
      _$PreReadingQuestionFromJson(json);
}
