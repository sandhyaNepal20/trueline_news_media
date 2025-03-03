import 'package:dio/dio.dart';
import 'package:trueline_news_media/app/constants/api_endpoints.dart';
import 'package:trueline_news_media/features/category/data/data_source/category_data_source.dart';
import 'package:trueline_news_media/features/category/data/model/category_api_model.dart';
import 'package:trueline_news_media/features/category/domain/entity/category_entity.dart';

class CategoryRemoteDataSource implements ICategoryDataSource {
  final Dio _dio;

  CategoryRemoteDataSource({required Dio dio}) : _dio = dio;

  @override
  Future<List<CategoryEntity>> getCategories() async {
    try {
      var response = await _dio.get(ApiEndpoints.getAllCategory);
      if (response.statusCode == 200) {
        List<dynamic> jsonList = response.data; // API response is a List
        List<CategoryApiModel> models =
            jsonList.map((json) => CategoryApiModel.fromJson(json)).toList();
        return CategoryApiModel.toEntityList(models); // Convert to entity list
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
