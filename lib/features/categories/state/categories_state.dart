import 'package:prokat/features/categories/models/category.dart';

class CategoryState {
  final bool isLoading;
  final String? error;

  final List<Category> categories;
  final Category? selectedCategory;

  CategoryState({
    this.isLoading = false,
    this.error,
    this.selectedCategory,
    this.categories = const [],
  });

  CategoryState copyWith({
    bool? isLoading,
    String? error,
    List<Category>? categories,
    Category? selectedCategory,
  }) {
    return CategoryState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}
