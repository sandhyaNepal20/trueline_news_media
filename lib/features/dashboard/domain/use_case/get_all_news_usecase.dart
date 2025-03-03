import 'package:dartz/dartz.dart';
import 'package:trueline_news_media/app/usecase/usecase.dart';
import 'package:trueline_news_media/core/error/failure.dart';
import 'package:trueline_news_media/features/dashboard/domain/entity/news_entity.dart';
import 'package:trueline_news_media/features/dashboard/domain/repository/news_repository.dart';

class GetAllNewsUseCase implements UsecaseWithoutParams<List<NewsEntity>> {
  final INewsRepository newsRepository;

  GetAllNewsUseCase({required this.newsRepository});

  @override
  Future<Either<Failure, List<NewsEntity>>> call() async {
    final response = await newsRepository.getNews();

    response.fold(
      (failure) => print("UseCase Error: ${failure.message}"),
      (news) {
        print("UseCase Fetched ${news.length} news");
        for (var news in news) {
          print("news: ${news.title}, created_at: ${news.created_at}");
        }
      },
    );

    return response;
  }
}
