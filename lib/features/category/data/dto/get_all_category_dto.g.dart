// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_category_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllCategoryDto _$GetAllCategoryDtoFromJson(Map<String, dynamic> json) =>
    GetAllCategoryDto(
      success: json['success'] as bool,
      count: (json['count'] as num).toInt(),
      data: (json['data'] as List<dynamic>)
          .map((e) => CategoryApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetAllCategoryDtoToJson(GetAllCategoryDto instance) =>
    <String, dynamic>{
      'success': instance.success,
      'count': instance.count,
      'data': instance.data,
    };
