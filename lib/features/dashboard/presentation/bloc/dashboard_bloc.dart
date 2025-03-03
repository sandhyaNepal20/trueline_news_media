import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:trueline_news_media/features/category/domain/entity/category_entity.dart';
import 'package:trueline_news_media/features/category/domain/use_case/get_all_category_usecase.dart';
import 'package:trueline_news_media/features/dashboard/domain/entity/news_entity.dart';
import 'package:trueline_news_media/features/dashboard/domain/use_case/get_all_news_usecase.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetAllNewsUseCase _getAllNewsUseCase;
  final GetAllCategoryUseCase
      _getAllCategoriesUseCase; // ✅ Inject category use case

  DashboardBloc({
    required GetAllNewsUseCase getAllNewsUseCase,
    required GetAllCategoryUseCase getAllCategoriesUseCase,
  })  : _getAllNewsUseCase = getAllNewsUseCase,
        _getAllCategoriesUseCase = getAllCategoriesUseCase,
        super(DashboardState.initial()) {
    on<LoadNews>(_onLoadNews);
    on<LoadCategories>(_onLoadCategories);
    on<FilterNewsByCategory>(_onFilterNewsByCategory);

    // ✅ Load both news and categories on startup
    add(LoadNews());
    add(LoadCategories());
  }

  /// ✅ **Fetch News Data**
  Future<void> _onLoadNews(LoadNews event, Emitter<DashboardState> emit) async {
    emit(state.copyWith(isLoading: true));

    final result = await _getAllNewsUseCase.call();

    result.fold(
      (failure) {
        print("API Error: ${failure.message}");
        emit(state.copyWith(isLoading: false, error: failure.message));
      },
      (news) {
        print("Fetched News: ${news.length}");
        emit(state.copyWith(isLoading: false, news: news));
      },
    );
  }

  /// ✅ **Fetch Categories from Backend**
  Future<void> _onLoadCategories(
      LoadCategories event, Emitter<DashboardState> emit) async {
    emit(state.copyWith(isLoading: true));

    final result = await _getAllCategoriesUseCase.call();

    result.fold(
      (failure) {
        print("Category API Error: ${failure.message}");
        emit(state.copyWith(isLoading: false, error: failure.message));
      },
      (categories) {
        print("Fetched Categories: ${categories.length}");

        // ✅ Ensure categories are properly stored in state
        emit(state.copyWith(isLoading: false, categories: categories));
      },
    );
  }

  /// ✅ **Filter News by Selected Category**
  void _onFilterNewsByCategory(
      FilterNewsByCategory event, Emitter<DashboardState> emit) {
    if (event.category == 'All') {
      emit(state.copyWith(news: state.news)); // Show all news
      return;
    }

    final filteredNews = state.news
        .where((news) =>
            news.categoryId != null &&
            news.categoryId!.categoryName == event.category)
        .toList();

    emit(state.copyWith(news: filteredNews));
  }
}
