import 'package:equatable/equatable.dart';
import 'package:trueline_news_media/features/category/domain/entity/category_entity.dart';

class NewsEntity extends Equatable {
  final String? newsId;
  final CategoryEntity? categoryId; // ✅ Make this nullable
  final String title;
  final String? image;
  final String content;
  final String created_at;

  const NewsEntity({
    required this.newsId,
    this.categoryId, // ✅ Now nullable to handle null values
    required this.title,
    this.image,
    required this.content,
    required this.created_at,
  });

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
