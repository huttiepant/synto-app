import 'package:json_annotation/json_annotation.dart';

part 'reading_progress.g.dart';


@JsonSerializable()
class ReadingProgress {
  int currentQuestionIndices;
  Map<int, dynamic> answeredQuestions;

  ReadingProgress({
    required this.currentQuestionIndices,
    required this.answeredQuestions,
  });

  void setAnswerByQuestionId(int questionId, answer) {
    answeredQuestions[questionId] = answer;
  }

  void setIndicesByQuestionId(index) {
    currentQuestionIndices = index;
  }

  factory ReadingProgress.fromJson(Map<String, dynamic> json) =>
      _$ReadingProgressFromJson(json);

  toJson() {
    return _$ReadingProgressToJson(this);
  }

}
