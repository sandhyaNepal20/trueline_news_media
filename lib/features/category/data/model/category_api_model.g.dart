// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryApiModel _$CategoryApiModelFromJson(Map<String, dynamic> json) =>
    CategoryApiModel(
      news_categoryId: json['_id'] as String?,
      categoryName: json['categoryName'] as String,
      categoryDescription: json['categoryDescription'] as String,
    );

Map<String, dynamic> _$CategoryApiModelToJson(CategoryApiModel instance) =>
    <String, dynamic>{
      '_id': instance.news_categoryId,
      'categoryName': instance.categoryName,
      'categoryDescription': instance.categoryDescription,
    };
