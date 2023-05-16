import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:tutopedia/components/shimmer_box.dart';
import 'package:tutopedia/constants/hive_boxes.dart';
import 'package:tutopedia/models/course_model.dart';
import 'package:tutopedia/screens/course_preview_screen.dart';
import 'package:tutopedia/screens/course_screen.dart';

class PopularCourses extends StatelessWidget {
  final List<CourseModel> courseList;
  const PopularCourses(this.courseList, {super.key});

  @override
  Widget build(BuildContext context) {
    if (courseList.isNotEmpty) {
      return CarouselSlider.builder(
        options: CarouselOptions(
          aspectRatio: 2.1,
          autoPlay: true,
          enlargeFactor: 0.19,
          enlargeCenterPage: true,
          scrollDirection: Axis.horizontal,
        ),
        itemCount: courseList.length,
        itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
          return InkWell(
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
            onTap: () {
              bool isEnrolled = false;
              if (myCoursesBox.isNotEmpty) {
                isEnrolled = myCoursesBox.containsKey(courseList[itemIndex].id);
              }
              if (isEnrolled) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CourseScreen(
                      course: courseList[itemIndex],
                      currentUserRating: myCoursesBox.get(courseList[itemIndex].id),
                    ),
                  ),
                );
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CoursePreviewScreen(
                      course: courseList[itemIndex],
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
                  imageUrl: "https://i.ytimg.com/vi/${courseList[itemIndex].link.substring(30, 41)}/maxresdefault.jpg",
                  placeholder: (context, url) {
                    return const ShimmerBox(
                      height: double.infinity,
                      width: double.infinity,
                      borderRadius: 10.0,
                      margin: 0.0,
                    );
                  },
                  errorWidget: (context, url, error) {
                    return Container(
                      width: double.infinity,
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
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      );
    } else {
      return CarouselSlider.builder(
        options: CarouselOptions(
          aspectRatio: 2.1,
          autoPlay: true,
          enlargeFactor: 0.19,
          enlargeCenterPage: true,
          scrollDirection: Axis.horizontal,
        ),
        itemCount: 5,
        itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
          return const ShimmerBox(
            height: double.infinity,
            width: double.infinity,
            borderRadius: 10.0,
            margin: 7.5,
          );
        },
      );
    }
  }
}
