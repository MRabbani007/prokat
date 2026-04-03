import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/features/categories/models/category.dart';
import 'package:prokat/features/categories/services/category_service.dart';
import 'package:prokat/features/categories/state/categories_state.dart';

class CategoriesNotifier extends StateNotifier<CategoryState> {
  final CategoryService service;

  CategoriesNotifier(this.service) : super(CategoryState()){
    // getCategories();
  }

  void selectCategory(Category? category) {
    state = state.copyWith(selectedCategory: category, showSelect: false);
  }

  void clearCategory(){
    state = state.copyWith(showSelect: true);
  }

  Future<void> getCategories() async {
    try {
      state = state.copyWith(isLoading: true);

      final data = await service.getCategories();

      state = state.copyWith(isLoading: false, categories: data);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        categories: [],
        error: e.toString(),
      );
    }
  }
}
