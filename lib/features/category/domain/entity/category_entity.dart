import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String? product_categoryId;
  final String categoryName;
  final String categoryDescription;

  const CategoryEntity({
    this.product_categoryId,
    required this.categoryName,
    required this.categoryDescription,
  });
  const CategoryEntity.empty()
      : product_categoryId = 'empty.product_categoryId',
        categoryName = 'empty.categoryName',
        categoryDescription = 'empty.categoryDescription';

  @override
  List<Object?> get props =>
      [product_categoryId, categoryName, categoryDescription];
}
