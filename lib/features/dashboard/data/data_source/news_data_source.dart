import 'package:trueline_news_media/features/dashboard/domain/entity/news_entity.dart';

abstract interface class INewsDataSource {
  Future<List<NewsEntity>> getNews();
  Future<void> createNews(NewsEntity news);
  Future<void> deleteNews(String id, String? token);
}
