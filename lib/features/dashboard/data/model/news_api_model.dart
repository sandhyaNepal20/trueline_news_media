import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:trueline_news_media/features/category/data/model/category_api_model.dart';
import 'package:trueline_news_media/features/dashboard/domain/entity/news_entity.dart';

part 'news_api_model.g.dart';

@JsonSerializable()
class NewsApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? newsId;

  @JsonKey(nullable: true)
  final CategoryApiModel? categoryId; // ✅ Make this nullable

  @JsonKey(nullable: true, defaultValue: "")
  final String title; // ✅ Default empty string to avoid null errors

  @JsonKey(nullable: true)
  final String? image;

  @JsonKey(nullable: true, defaultValue: "")
  final String content; // ✅ Default empty string

  @JsonKey(nullable: true, defaultValue: "")
  final String created_at; // ✅ Default empty string

  const NewsApiModel({
    this.newsId,
    this.categoryId, // ✅ Now nullable to handle missing data
    required this.title,
    this.image,
    required this.content,
    required this.created_at,
  });

  /// **Factory constructor to create an instance from JSON**
  factory NewsApiModel.fromJson(Map<String, dynamic> json) =>
      _$NewsApiModelFromJson(json);

  /// **Method to convert object to JSON**
  Map<String, dynamic> toJson() => _$NewsApiModelToJson(this);

  /// **Convert API Model to Entity**
  NewsEntity toEntity() {
    return NewsEntity(
      newsId: newsId,
      categoryId: categoryId?.toEntity(), // ✅ Only convert if not null
      title: title,
      image: image,
      content: content,
      created_at: created_at,
    );
  }

  /// **Convert Entity to API Model**
  factory NewsApiModel.fromEntity(NewsEntity entity) {
    return NewsApiModel(
      newsId: entity.newsId,
      categoryId: entity.categoryId != null
          ? CategoryApiModel.fromEntity(entity.categoryId!)
          : null, // ✅ Convert only if not null
      title: entity.title,
      image: entity.image,
      content: entity.content,
      created_at: entity.created_at,
    );
  }

  /// **Convert API List to Entity List**
  static List<NewsEntity> toEntityList(List<NewsApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  List<Object?> get props => [
        newsId,
        categoryId, // ✅ Allow null categoryId
        title,
        image,
        content,
        created_at,
      ];
}
