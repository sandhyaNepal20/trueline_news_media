import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:trueline_news_media/features/dashboard/domain/entity/news_entity.dart';
import 'package:trueline_news_media/features/dashboard/domain/use_case/get_all_news_usecase.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetAllNewsUseCase _getAllNewsUseCase;

  DashboardBloc({
    required GetAllNewsUseCase getAllNewsUseCase,
  })  : _getAllNewsUseCase = getAllNewsUseCase,
        super(DashboardState.initial()) {
    on<LoadNews>(_onLoadNews);

    // Call this event whenever the bloc is created to load the batches
    add(LoadNews());
  }

  Future<void> _onLoadNews(LoadNews event, Emitter<DashboardState> emit) async {
    emit(state.copyWith(isLoading: true));

    final result = await _getAllNewsUseCase.call();

    result.fold(
      (failure) {
        print("API Error: ${failure.message}");
        emit(state.copyWith(isLoading: false, error: failure.message));
      },
      (news) {
        print("Fetched News: ${news.length}"); // Debugging
        for (var news in news) {
          print("Product Name: ${news.title}, Price: ${news.created_at}");
        }
        emit(state.copyWith(isLoading: false, news: news));
      },
    );
  }
}
