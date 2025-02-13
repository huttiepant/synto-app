import 'package:json_annotation/json_annotation.dart';

part 'answer.g.dart';

@JsonSerializable(createToJson: false)
class Answer {
  final int id;
  final String answer;
  final String dialogue;
  final bool? correct;

  Answer({
    required this.id,
    required this.answer,
    required this.dialogue,
    required this.correct,
  });

  factory Answer.fromJson(Map<String, dynamic> json) => _$AnswerFromJson(json);
}
