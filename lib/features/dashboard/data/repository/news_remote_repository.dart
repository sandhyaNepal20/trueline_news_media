import 'package:dartz/dartz.dart';
import 'package:trueline_news_media/core/error/failure.dart';
import 'package:trueline_news_media/features/dashboard/data/data_source/remote_datasource/news_remote_datasource.dart';
import 'package:trueline_news_media/features/dashboard/domain/entity/news_entity.dart';
import 'package:trueline_news_media/features/dashboard/domain/repository/news_repository.dart';

class NewsRemoteRepository implements INewsRepository {
  final NewsRemoteDataSource remoteDataSource;

  NewsRemoteRepository({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> createNews(NewsEntity news) {
    // TODO: implement createNews
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> deleteNews(String id, String? token) {
    // TODO: implement deleteNews
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<NewsEntity>>> getNews() async {
    try {
      final news = await remoteDataSource.getNews();
      return Right(news);
    } catch (e) {
      return Left(
        ApiFailure(
          message: e.toString(),
        ),
      );
    }
  }
}
