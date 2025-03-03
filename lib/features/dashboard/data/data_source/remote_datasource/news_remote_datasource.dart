import 'package:dio/dio.dart';
import 'package:trueline_news_media/app/constants/api_endpoints.dart';
import 'package:trueline_news_media/features/dashboard/data/data_source/news_data_source.dart';
import 'package:trueline_news_media/features/dashboard/data/dto/get_all_news_dto.dart';
import 'package:trueline_news_media/features/dashboard/data/model/news_api_model.dart';
import 'package:trueline_news_media/features/dashboard/domain/entity/news_entity.dart';

class NewsRemoteDataSource implements INewsDataSource {
  final Dio _dio;

  NewsRemoteDataSource({
    required Dio dio,
  }) : _dio = dio;

  @override
  Future<List<NewsEntity>> getNews() async {
    try {
      var response = await _dio.get(ApiEndpoints.getAllNews);

      if (response.statusCode == 200) {
        // Check if response.data is a list instead of a map
        if (response.data is List) {
          // Manually construct a map with a dummy `success` and `count`
          Map<String, dynamic> jsonData = {
            "success": true,
            "count": response.data.length,
            "data": response.data
          };

          GetAllNewsDTO getAllNewsDTO = GetAllNewsDTO.fromJson(jsonData);
          return NewsApiModel.toEntityList(getAllNewsDTO.data);
        } else {
          throw Exception("Invalid response format");
        }
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> createNews(NewsEntity news) {
    // TODO: implement createNews
    throw UnimplementedError();
  }

  @override
  Future<void> deleteNews(String id, String? token) {
    // TODO: implement deleteNews
    throw UnimplementedError();
  }
}
