class TopicModel {
  final String id;
  final String title;
  final String image;
  TopicModel({
    required this.id,
    required this.title,
    required this.image,
  });

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
      id: json['_id'] ?? "",
      title: json['name'] ?? "",
      image: "assets/images/${json['name'].toString().toLowerCase()}.png",
    );
  }
}
