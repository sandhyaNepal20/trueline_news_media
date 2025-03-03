part of 'dashboard_bloc.dart';

class DashboardState extends Equatable {
  final List<NewsEntity> news;
  final List<CategoryEntity> categories; // Added categories
  final bool isLoading;
  final String? error;

  const DashboardState({
    required this.news,
    required this.categories,
    required this.isLoading,
    this.error,
  });

  factory DashboardState.initial() {
    return const DashboardState(
      news: [],
      categories: [], // Initialize as empty list
      isLoading: false,
    );
  }

  DashboardState copyWith({
    List<NewsEntity>? news,
    List<CategoryEntity>? categories,
    bool? isLoading,
    String? error,
  }) {
    return DashboardState(
      news: news ?? this.news,
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [news, categories, isLoading, error];
}
