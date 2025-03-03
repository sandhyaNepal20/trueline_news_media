import 'package:dartz/dartz.dart';
import 'package:trueline_news_media/core/error/failure.dart';
import 'package:trueline_news_media/features/dashboard/domain/entity/news_entity.dart';

abstract interface class INewsRepository {
  Future<Either<Failure, List<NewsEntity>>> getNews();
  Future<Either<Failure, void>> createNews(NewsEntity news);
  Future<Either<Failure, void>> deleteNews(String id, String? token);
}
