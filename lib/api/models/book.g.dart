// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Book _$BookFromJson(Map<String, dynamic> json) => Book(
      image: json['image'] as String,
      author: json['author'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      hashtags: json['hashtags'] as String,
    );

Map<String, dynamic> _$BookToJson(Book instance) => <String, dynamic>{
      'image': instance.image,
      'author': instance.author,
      'title': instance.title,
      'description': instance.description,
      'hashtags': instance.hashtags,
    };
