import 'package:trueline_news_media/features/category/domain/entity/category_entity.dart';

abstract interface class ICategoryDataSource {
  Future<List<CategoryEntity>> getCategories();
}
