import 'package:flutter/material.dart';
import 'package:tutopedia/components/course_slide_view.dart';
import 'package:tutopedia/components/shimmer_box.dart';
import 'package:tutopedia/models/course_model.dart';

class NewCourses extends StatelessWidget {
  final List<CourseModel> courseList;
  const NewCourses(this.courseList, {super.key});

  @override
  Widget build(BuildContext context) {
    if (courseList.isNotEmpty) {
      return CourseSlideView(courseList);
    } else {
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.filled(5, 0).map((item) {
            return const ShimmerBox(
              height: 112.5,
              width: 200.0,
              borderRadius: 10.0,
              margin: 7.5,
            );
          }).toList(),
        ),
      );
    }
  }
}
