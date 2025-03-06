// test/dashboard_bloc_test.dart

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trueline_news_media/core/error/failure.dart';
import 'package:trueline_news_media/features/category/domain/entity/category_entity.dart';
import 'package:trueline_news_media/features/category/domain/use_case/get_all_category_usecase.dart';
import 'package:trueline_news_media/features/dashboard/domain/entity/news_entity.dart';
import 'package:trueline_news_media/features/dashboard/domain/use_case/get_all_news_usecase.dart';
import 'package:trueline_news_media/features/dashboard/presentation/bloc/dashboard_bloc.dart';

/// Mocks
class MockGetAllNewsUseCase extends Mock implements GetAllNewsUseCase {}

class MockGetAllCategoryUseCase extends Mock implements GetAllCategoryUseCase {}

/// Dummy data for testing.
const dummyCategory1 = CategoryEntity(
  categoryName: 'Sports',
  categoryDescription: '',
);

const dummyCategory2 = CategoryEntity(
  categoryName: 'Politics',
  categoryDescription: '',
);

const dummyNews1 = NewsEntity(
  title: 'Sports News 1',
  content: 'Content for sports news',
  categoryId: dummyCategory1,
  newsId: '',
  created_at: '',
);

const dummyNews2 = NewsEntity(
  title: 'Politics News 1',
  content: 'Content for politics news',
  categoryId: dummyCategory2,
  newsId: '',
  created_at: '',
);

final dummyNewsList = [dummyNews1, dummyNews2];
final dummyCategoriesList = [dummyCategory1, dummyCategory2];

void main() {
  late MockGetAllNewsUseCase mockGetAllNewsUseCase;
  late MockGetAllCategoryUseCase mockGetAllCategoryUseCase;

  setUp(() {
    mockGetAllNewsUseCase = MockGetAllNewsUseCase();
    mockGetAllCategoryUseCase = MockGetAllCategoryUseCase();
  });

  group('DashboardBloc', () {
    blocTest<DashboardBloc, DashboardState>(
      'emits [isLoading: true, news: dummyNewsList] when LoadNews is successful',
      build: () {
        when(() => mockGetAllNewsUseCase.call())
            .thenAnswer((_) async => Right(dummyNewsList));
        // Return a bloc that will only run the LoadNews handler.
        return DashboardBloc(
          getAllNewsUseCase: mockGetAllNewsUseCase,
          getAllCategoriesUseCase: mockGetAllCategoryUseCase,
        );
      },
      act: (bloc) async {
        // Clear any automatic events dispatched in the constructor if needed.
        // Manually add the event for testing purposes.
        bloc.add(LoadNews());
      },
      expect: () => [
        // First, it emits a loading state.
        DashboardState.initial().copyWith(isLoading: true),
        // Then, a state with the news loaded.
        DashboardState.initial()
            .copyWith(isLoading: false, news: dummyNewsList),
      ],
      verify: (_) {
        verify(() => mockGetAllNewsUseCase.call())
            .called(greaterThanOrEqualTo(1));
      },
    );

    blocTest<DashboardBloc, DashboardState>(
      'emits [isLoading: true, error: failure message] when LoadNews fails',
      build: () {
        when(() => mockGetAllNewsUseCase.call()).thenAnswer(
          (_) async => const Left(ApiFailure(message: 'News load failed')),
        );
        return DashboardBloc(
          getAllNewsUseCase: mockGetAllNewsUseCase,
          getAllCategoriesUseCase: mockGetAllCategoryUseCase,
        );
      },
      act: (bloc) {
        bloc.add(LoadNews());
      },
      expect: () => [
        DashboardState.initial().copyWith(isLoading: true),
        DashboardState.initial()
            .copyWith(isLoading: false, error: 'News load failed'),
      ],
      verify: (_) {
        verify(() => mockGetAllNewsUseCase.call())
            .called(greaterThanOrEqualTo(1));
      },
    );

    blocTest<DashboardBloc, DashboardState>(
      'emits [isLoading: true, categories: dummyCategoriesList] when LoadCategories is successful',
      build: () {
        when(() => mockGetAllCategoryUseCase.call())
            .thenAnswer((_) async => Right(dummyCategoriesList));
        return DashboardBloc(
          getAllNewsUseCase: mockGetAllNewsUseCase,
          getAllCategoriesUseCase: mockGetAllCategoryUseCase,
        );
      },
      act: (bloc) {
        bloc.add(LoadCategories());
      },
      expect: () => [
        DashboardState.initial().copyWith(isLoading: true),
        DashboardState.initial()
            .copyWith(isLoading: false, categories: dummyCategoriesList),
      ],
      verify: (_) {
        verify(() => mockGetAllCategoryUseCase.call())
            .called(greaterThanOrEqualTo(1));
      },
    );

    blocTest<DashboardBloc, DashboardState>(
      'emits [isLoading: true, error: failure message] when LoadCategories fails',
      build: () {
        when(() => mockGetAllCategoryUseCase.call()).thenAnswer(
          (_) async => const Left(ApiFailure(message: 'Category load failed')),
        );
        return DashboardBloc(
          getAllNewsUseCase: mockGetAllNewsUseCase,
          getAllCategoriesUseCase: mockGetAllCategoryUseCase,
        );
      },
      act: (bloc) {
        bloc.add(LoadCategories());
      },
      expect: () => [
        DashboardState.initial().copyWith(isLoading: true),
        DashboardState.initial()
            .copyWith(isLoading: false, error: 'Category load failed'),
      ],
      verify: (_) {
        verify(() => mockGetAllCategoryUseCase.call())
            .called(greaterThanOrEqualTo(1));
      },
    );
  });
}
