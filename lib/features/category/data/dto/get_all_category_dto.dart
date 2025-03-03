import 'package:json_annotation/json_annotation.dart';
import 'package:trueline_news_media/features/category/data/model/category_api_model.dart';

part 'get_all_category_dto.g.dart';

@JsonSerializable()
class GetAllCategoryDto {
  final bool success;
  final int count;
  final List<CategoryApiModel> data;

  GetAllCategoryDto({
    required this.success,
    required this.count,
    required this.data,
  });
  Map<String, dynamic> toJson() => _$GetAllCategoryDtoToJson(this);

  factory GetAllCategoryDto.fromJson(Map<String, dynamic> json) =>
      _$GetAllCategoryDtoFromJson(json);
}
