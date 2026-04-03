import 'package:prokat/features/categories/models/category.dart';

class CategoryState {
  final bool isLoading;
  final String? error;

  final List<Category> categories;
  final Category? selectedCategory;

  final bool? showSelect;

  CategoryState({
    this.isLoading = false,
    this.error,
    this.selectedCategory,
    this.showSelect,
    this.categories = const [],
  });

  CategoryState copyWith({
    bool? isLoading,
    String? error,
    List<Category>? categories,
    Category? selectedCategory,
    bool? showSelect,
  }) {
    return CategoryState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      showSelect: showSelect ?? this.showSelect,
    );
  }
}
