import 'package:json_annotation/json_annotation.dart';
import 'package:synto_app/api/models/post_reading_question.dart';
import 'package:synto_app/api/models/pre_reading_question.dart';
import 'package:synto_app/api/models/while_reading_question.dart';
import 'package:synto_app/services/books_service.dart';

part 'book.g.dart';

@JsonSerializable(createToJson: false)
class Book {
  final String name;
  final String author;
  final String description;
  final String info;
  final String? themes;
  final int id;
  final List<PreReadingQuestion> preReading;
  final List<WhileReadingQuestion> whileReading;
  final List<PostReadingQuestion> postReading;
  final List<String> tags;

  Book({
    required this.name,
    required this.author,
    required this.description,
    required this.info,
    required this.id,
    required this.preReading,
    required this.whileReading,
    required this.postReading,
    required this.tags,
    this.themes,
  });

  List<dynamic> getCurrentStepQuestions(ReadingStep step) {
    switch (step) {
      case ReadingStep.preReading:
        return preReading;
      case ReadingStep.whileReading:
        return whileReading;
      case ReadingStep.postReading:
        return postReading;
    }
  }

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);
}
