// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsApiModel _$NewsApiModelFromJson(Map<String, dynamic> json) => NewsApiModel(
      newsId: json['_id'] as String?,
      categoryId: json['categoryId'] == null
          ? null
          : CategoryApiModel.fromJson(
              json['categoryId'] as Map<String, dynamic>),
      title: json['title'] as String? ?? '',
      image: json['image'] as String?,
      content: json['content'] as String? ?? '',
      created_at: json['created_at'] as String? ?? '',
    );

Map<String, dynamic> _$NewsApiModelToJson(NewsApiModel instance) =>
    <String, dynamic>{
      '_id': instance.newsId,
      'categoryId': instance.categoryId,
      'title': instance.title,
      'image': instance.image,
      'content': instance.content,
      'created_at': instance.created_at,
    };
