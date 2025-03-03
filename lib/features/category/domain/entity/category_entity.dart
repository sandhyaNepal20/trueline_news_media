import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String? news_categoryId;
  final String categoryName;
  final String categoryDescription;

  const CategoryEntity({
    this.news_categoryId,
    required this.categoryName,
    required this.categoryDescription,
  });
  const CategoryEntity.empty()
      : news_categoryId = 'empty.news_categoryId',
        categoryName = 'empty.categoryName',
        categoryDescription = 'empty.categoryDescription';

  @override
  List<Object?> get props =>
      [news_categoryId, categoryName, categoryDescription];
}
