import 'package:json_annotation/json_annotation.dart';
import 'package:synto_app/api/models/question_progress.dart';
import 'package:synto_app/api/models/reading_progress.dart';

part 'user_progress.g.dart';

@JsonSerializable()
class UserProgress {
  final Map<int, QuestionProgress> progress;

  UserProgress({
    required this.progress,
  });

  void setProgress(int bookId, ReadingProgress readingProgress) {
    progress[bookId]!.setReadingProgress(readingProgress);
  }

  factory UserProgress.fromJson(Map<String, dynamic> json) =>
      _$UserProgressFromJson(json);

  toJson() {
    return _$UserProgressToJson(this);
  }
}
