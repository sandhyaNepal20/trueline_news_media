import 'package:dartz/dartz.dart';
import 'package:trueline_news_media/app/usecase/usecase.dart';
import 'package:trueline_news_media/core/error/failure.dart';
import 'package:trueline_news_media/features/category/domain/entity/category_entity.dart';
import 'package:trueline_news_media/features/category/domain/repository/category_repository.dart';

class GetAllCategoryUseCase
    implements UsecaseWithoutParams<List<CategoryEntity>> {
  final ICategoryRepository categoryRepository;

  GetAllCategoryUseCase({required this.categoryRepository});

  @override
  Future<Either<Failure, List<CategoryEntity>>> call() async {
    final response = await categoryRepository.getCategories();

    response.fold(
      (failure) => print("Category UseCase Error: ${failure.message}"),
      (categories) {
        print("UseCase Fetched ${categories.length} categories");
        for (var category in categories) {
          print("Category: ${category.categoryName}");
        }
      },
    );

    return response;
  }
}
