// features/categories/providers/category_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../../core/providers/api_provider.dart';
import '../models/category.dart';
import '../services/category_service.dart';

final categoryServiceProvider = Provider<CategoryService>((ref) {
  final Dio dio = ref.watch(dioProvider);
  return CategoryService(dio);
});

final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final service = ref.watch(categoryServiceProvider);

  // ref.keepAlive();

  return service.getCategories();
});

// Add this to your category_provider.dart
final selectedCategoryProvider = StateProvider<Category?>((ref) => null);
