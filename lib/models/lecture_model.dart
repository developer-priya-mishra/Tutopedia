class LectureModel {
  final String id;
  final String title;
  final String time;
  final String link;
  final String description;
  final String updatedAt;

  LectureModel({
    required this.id,
    required this.title,
    required this.time,
    required this.link,
    required this.description,
    required this.updatedAt,
  });

  factory LectureModel.fromJson(Map<String, dynamic> json) {
    return LectureModel(
      id: json['_id'] ?? "",
      title: json['title'] ?? "",
      time: json['time'] ?? "",
      link: json['link'] ?? "",
      description: json['description'] ?? "",
      updatedAt: json['updated_at'] ?? "",
    );
  }
}
