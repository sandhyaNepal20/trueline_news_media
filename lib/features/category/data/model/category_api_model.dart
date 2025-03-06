import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:trueline_news_media/features/category/domain/entity/category_entity.dart';

@JsonSerializable()
class CategoryApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? product_categoryId;
  final String categoryName;
  final String categoryDescription;

  const CategoryApiModel({
    this.product_categoryId,
    required this.categoryName,
    required this.categoryDescription,
  });

  const CategoryApiModel.empty()
      : product_categoryId = '',
        categoryName = '',
        categoryDescription = '';

  // From Json , write full code without generator
  factory CategoryApiModel.fromJson(Map<String, dynamic> json) {
    return CategoryApiModel(
      product_categoryId: json['_id'],
      categoryName: json['name'],
      categoryDescription: json['description'],
    );
  }

  // To Json , write full code without generator
  Map<String, dynamic> toJson() {
    return {
      '_id': product_categoryId,
      'name': categoryName,
      'description': categoryDescription,
    };
  }

  // Convert API Object to Entity
  CategoryEntity toEntity() => CategoryEntity(
        product_categoryId: product_categoryId,
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
        product_categoryId,
        categoryName,
        categoryDescription,
      ];
}
