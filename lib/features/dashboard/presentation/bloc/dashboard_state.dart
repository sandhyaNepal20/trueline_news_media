part of 'dashboard_bloc.dart';

class DashboardState extends Equatable {
  final List<NewsEntity> news;
  final bool isLoading;
  final String? error;

  const DashboardState({
    required this.news,
    required this.isLoading,
    this.error,
  });

  factory DashboardState.initial() {
    return const DashboardState(
      news: [],
      isLoading: false,
    );
  }

  DashboardState copyWith({
    List<NewsEntity>? news,
    bool? isLoading,
    String? error,
  }) {
    return DashboardState(
      news: news ?? this.news,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [news, isLoading, error];
}
