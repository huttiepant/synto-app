import 'package:json_annotation/json_annotation.dart';

part 'book.g.dart';

@JsonSerializable()
class Book {
  final String image;
  final String author;
  final String title;
  final String description;
  final String hashtags;

  Book({
    required this.image,
    required this.author,
    required this.title,
    required this.description,
    required this.hashtags,
  });

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);

  Map<String, dynamic> toJson() => _$BookToJson(this);
}
