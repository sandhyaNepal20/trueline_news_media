import 'package:dartz/dartz.dart';
import 'package:trueline_news_media/app/usecase/usecase.dart';
import 'package:trueline_news_media/core/error/failure.dart';
import 'package:trueline_news_media/features/category/domain/entity/category_entity.dart';
import 'package:trueline_news_media/features/category/domain/repository/category_repository.dart';

class GetAllCategoryUsecase
    implements UsecaseWithoutParams<List<CategoryEntity>> {
  final ICategoryRepository categoryRepository;

  GetAllCategoryUsecase({required this.categoryRepository});

  @override
  Future<Either<Failure, List<CategoryEntity>>> call() {
    return categoryRepository.getCategories();
  }
}
