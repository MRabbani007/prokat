import 'package:dio/dio.dart';
import '../../../core/api/base_repository.dart';
import '../../../core/constants/api_routes.dart';
import '../models/category.dart';

class CategoryService extends BaseRepository {
  final Dio dio;

  CategoryService(this.dio);

  Future<List<Category>> getCategories() {
    return execute(() async {
      final response = await dio.get(ApiRoutes.categories);

      final List data = response.data["data"];

      final categories = data.map((json) => Category.fromJson(json)).toList();

      categories.sort((a, b) => a.sortIndex.compareTo(b.sortIndex));

      return categories;
    });
  }
}
