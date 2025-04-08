// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Book _$BookFromJson(Map<String, dynamic> json) => Book(
      name: json['name'] as String,
      author: json['author'] as String,
      description: json['description'] as String,
      info: json['info'] as String,
      id: (json['id'] as num).toInt(),
      preReading: (json['preReading'] as List<dynamic>)
          .map((e) => PreReadingQuestion.fromJson(e as Map<String, dynamic>))
          .toList(),
      whileReading: (json['whileReading'] as List<dynamic>)
          .map((e) => WhileReadingQuestion.fromJson(e as Map<String, dynamic>))
          .toList(),
      postReading: (json['postReading'] as List<dynamic>)
          .map((e) => PostReadingQuestion.fromJson(e as Map<String, dynamic>))
          .toList(),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      themes: json['themes'] as String?,
    );
