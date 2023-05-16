import 'package:tutopedia/models/lecture_model.dart';

class CourseModel {
  final String id;
  final String title;
  final String channelName;
  final String uploadedBy;
  final String link;
  final String description;
  final String rating;
  final String studentEnrolled;
  final List<LectureModel> lectureList;
  final String mainCategory;
  final String subCategory;
  final String topic;

  CourseModel({
    required this.id,
    required this.title,
    required this.channelName,
    required this.uploadedBy,
    required this.link,
    required this.description,
    required this.rating,
    required this.studentEnrolled,
    required this.lectureList,
    required this.mainCategory,
    required this.subCategory,
    required this.topic,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    List<LectureModel> lectures = [];

    if (json['lectures'] is List) {
      for (var lecture in json['lectures']) {
        lectures.add(LectureModel.fromJson(lecture));
      }
    }

    return CourseModel(
      id: json['id'] ?? "",
      title: json['title'] ?? "",
      channelName: json['channel_name'] ?? "",
      uploadedBy: json['uploaded_by'] ?? "",
      link: json['link'] ?? "",
      description: json['description'] ?? "",
      rating: json['rating'].toString(),
      studentEnrolled: json['student_enrolled'].toString(),
      lectureList: lectures,
      mainCategory: json['main_category'] ?? "",
      subCategory: json['sub_category'] ?? "",
      topic: json['topic'] ?? "",
    );
  }
}
