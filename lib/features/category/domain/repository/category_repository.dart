import 'package:dartz/dartz.dart';
import 'package:trueline_news_media/core/error/failure.dart';
import 'package:trueline_news_media/features/category/domain/entity/category_entity.dart';

abstract interface class ICategoryRepository {
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
}
