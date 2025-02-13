import 'package:json_annotation/json_annotation.dart';
import 'package:synto_app/api/models/reading_progress.dart';
import 'package:synto_app/services/books_service.dart';

part 'question_progress.g.dart';

@JsonSerializable()
class QuestionProgress {
  final ReadingProgress preReading;
  final ReadingProgress whileReading;
  final ReadingProgress postReading;
  ReadingStep readingStep = ReadingStep.preReading;

  get currentStep {
    return readingStep;
  }

  set currentStep(step) {
    readingStep = step;
  }

  QuestionProgress({
    required this.preReading,
    required this.whileReading,
    required this.postReading,
    required this.readingStep,
  });

  ReadingProgress getCurrentReadingProgress() {
    switch (currentStep) {
      case ReadingStep.preReading:
        return preReading;
      case ReadingStep.whileReading:
        return whileReading;
      case ReadingStep.postReading:
        return postReading;
    }
    return preReading;
  }

  void setNextStep() {
    switch (currentStep) {
      case ReadingStep.preReading:
        currentStep(ReadingStep.whileReading);
        break;
      case ReadingStep.whileReading:
        currentStep(ReadingStep.postReading);
        break;
      case ReadingStep.postReading:
        break;
    }
  }

  void setReadingProgress(ReadingProgress progress) {
    final readingProgress = getCurrentReadingProgress();
    readingProgress.currentQuestionIndices = progress.currentQuestionIndices;
    readingProgress.answeredQuestions = progress.answeredQuestions;
  }

  factory QuestionProgress.fromJson(Map<String, dynamic> json) =>
      _$QuestionProgressFromJson(json);

  toJson() {
    return _$QuestionProgressToJson(this);
  }
}
