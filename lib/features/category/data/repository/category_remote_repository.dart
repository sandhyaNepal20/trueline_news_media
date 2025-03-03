import 'package:dartz/dartz.dart';
import 'package:trueline_news_media/core/error/failure.dart';
import 'package:trueline_news_media/features/category/data/data_source/remote_datasource/category_remote_data_source.dart';
import 'package:trueline_news_media/features/category/domain/entity/category_entity.dart';
import 'package:trueline_news_media/features/category/domain/repository/category_repository.dart';

class CategoryRemoteRepository implements ICategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRemoteRepository({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      final categories = await remoteDataSource
          .getCategories(); // ✅ Fetch categories from remote data source
      return Right(categories);
    } catch (e) {
      return Left(
        ApiFailure(
          message: e.toString(),
        ),
      );
    }
  }
}
