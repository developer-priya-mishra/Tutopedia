class MainCategoryModel {
  final String id;
  final String title;
  final int numberOfCourses;

  MainCategoryModel({
    required this.id,
    required this.title,
    required this.numberOfCourses,
  });

  factory MainCategoryModel.fromJson(Map<String, dynamic> json) {
    return MainCategoryModel(
      id: json['id'] ?? "",
      title: json['title'] ?? "",
      numberOfCourses: json['number_of_courses'] ?? 0,
    );
  }
}
