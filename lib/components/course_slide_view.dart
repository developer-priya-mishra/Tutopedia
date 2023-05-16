import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tutopedia/components/shimmer_box.dart';
import 'package:tutopedia/constants/hive_boxes.dart';
import 'package:tutopedia/models/course_model.dart';
import 'package:tutopedia/screens/course_preview_screen.dart';
import 'package:tutopedia/screens/course_screen.dart';

class CourseSlideView extends StatelessWidget {
  final List<CourseModel> courseList;
  const CourseSlideView(this.courseList, {super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: courseList.map((item) {
          return InkWell(
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
            onTap: () {
              bool isEnrolled = false;
              if (myCoursesBox.isNotEmpty) {
                isEnrolled = myCoursesBox.containsKey(item.id);
              }
              if (isEnrolled) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CourseScreen(
                      course: item,
                      currentUserRating: myCoursesBox.get(item.id),
                    ),
                  ),
                );
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CoursePreviewScreen(
                      course: item,
                    ),
                  ),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(7.5),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                child: CachedNetworkImage(
                  imageUrl: "https://i.ytimg.com/vi/${item.link.substring(30, 41)}/maxresdefault.jpg",
                  placeholder: (context, url) {
                    return const ShimmerBox(
                      height: 112.0,
                      width: 200.0,
                      borderRadius: 10.0,
                      margin: 0.0,
                    );
                  },
                  errorWidget: (context, url, error) {
                    return Container(
                      height: 112.0,
                      width: 200.0,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        color: Colors.grey.shade100,
                      ),
                      child: Icon(
                        Icons.broken_image_rounded,
                        color: Colors.grey.shade600,
                        size: 35.0,
                      ),
                    );
                  },
                  height: 112.5,
                  width: 200.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
