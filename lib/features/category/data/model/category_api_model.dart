import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:trueline_news_media/features/category/domain/entity/category_entity.dart';

part 'category_api_model.g.dart';

@JsonSerializable()
class CategoryApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? news_categoryId;
  final String categoryName;
  final String categoryDescription;

  const CategoryApiModel({
    this.news_categoryId,
    required this.categoryName,
    required this.categoryDescription,
  });

  const CategoryApiModel.empty()
      : news_categoryId = '',
        categoryName = '',
        categoryDescription = '';

  // From Json , write full code without generator
  factory CategoryApiModel.fromJson(Map<String, dynamic> json) {
    return CategoryApiModel(
      news_categoryId: json['_id'],
      categoryName: json['name'],
      categoryDescription: json['description'],
    );
  }

  // To Json , write full code without generator
  Map<String, dynamic> toJson() {
    return {
      '_id': news_categoryId,
      'name': categoryName,
      'description': categoryDescription,
    };
  }

  // Convert API Object to Entity
  CategoryEntity toEntity() => CategoryEntity(
        news_categoryId: news_categoryId,
        categoryName: categoryName,
        categoryDescription: categoryDescription,
      );

  // Convert Entity to API Object
  static CategoryApiModel fromEntity(CategoryEntity entity) => CategoryApiModel(
        categoryName: entity.categoryName,
        categoryDescription: entity.categoryDescription,
      );

  // Convert API List to Entity List
  static List<CategoryEntity> toEntityList(List<CategoryApiModel> models) =>
      models.map((model) => model.toEntity()).toList();

  @override
  List<Object?> get props => [
        news_categoryId,
        categoryName,
        categoryDescription,
      ];
}
