// features/categories/models/category.dart

class Category {
  final String id;
  final String name;
  final String capacityUnit;
  final int sortIndex;
  // final bool isUserVisible;
  // final bool isOwnerVisible;
  final String? imageUrl;

  Category({
    required this.id,
    required this.name,
    required this.capacityUnit,
    required this.sortIndex,
    // required this.isUserVisible,
    // required this.isOwnerVisible,
    this.imageUrl,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json["id"],
      name: json["name"],
      capacityUnit: json["capacityUnit"],
      sortIndex: json["sortIndex"] ?? 0,
      // isUserVisible: json["isUserVisible"] ?? false,
      // isOwnerVisible: json["isOwnerVisible"] ?? false,
      imageUrl: json["imageUrl"],
    );
  }
}
