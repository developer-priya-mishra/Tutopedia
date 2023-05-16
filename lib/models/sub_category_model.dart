class SubCategoryModel {
  final String id;
  final String title;
  final String mainCategoryId;

  SubCategoryModel({
    required this.id,
    required this.title,
    required this.mainCategoryId,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['_id'] ?? "",
      title: json['title'] ?? "",
      mainCategoryId: json['main_category_id'] ?? "",
    );
  }
}
