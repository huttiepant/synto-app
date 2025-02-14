import 'package:json_annotation/json_annotation.dart';

part 'post_reading_question.g.dart';

@JsonSerializable(createToJson: false)
class PostReadingQuestion {
  final int id;
  final String type;
  final String question;
  final String? info;
  final String? tips;
  final String? dialog;

  PostReadingQuestion({
    required this.id,
    required this.type,
    required this.question,
    this.info,
    this.tips,
    this.dialog,
  });

  factory PostReadingQuestion.fromJson(Map<String, dynamic> json) =>
      _$PostReadingQuestionFromJson(json);
}
