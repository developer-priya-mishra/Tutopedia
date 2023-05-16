import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tutopedia/components/shimmer_box.dart';
import 'package:tutopedia/constants/hive_boxes.dart';
import 'package:tutopedia/models/course_model.dart';
import 'package:tutopedia/screens/course_preview_screen.dart';
import 'package:tutopedia/screens/course_screen.dart';

class CourseView extends StatelessWidget {
  final List<CourseModel> courseList;
  final bool shrinkWrap;

  const CourseView({
    super.key,
    required this.courseList,
    required this.shrinkWrap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: shrinkWrap,
      physics: shrinkWrap ? const ScrollPhysics() : null,
      itemCount: courseList.length,
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 5.0,
      ),
      itemBuilder: (context, index) {
        return InkWell(
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
          onTap: () {
            bool isEnrolled = false;
            if (myCoursesBox.isNotEmpty) {
              isEnrolled = myCoursesBox.containsKey(courseList[index].id);
            }
            if (isEnrolled) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CourseScreen(
                    course: courseList[index],
                    currentUserRating: myCoursesBox.get(courseList[index].id),
                  ),
                ),
              );
            } else {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CoursePreviewScreen(
                    course: courseList[index],
                  ),
                ),
              );
            }
          },
          child: SizedBox(
            height: MediaQuery.of(context).size.width * 0.28,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 4.0, 8.0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    child: CachedNetworkImage(
                      imageUrl: "https://i.ytimg.com/vi/${courseList[index].link.substring(30, 41)}/maxresdefault.jpg",
                      placeholder: (context, url) {
                        return ShimmerBox(
                          height: double.maxFinite,
                          width: MediaQuery.of(context).size.width * 0.40,
                          borderRadius: 10.0,
                          margin: 0.0,
                        );
                      },
                      errorWidget: (context, url, error) {
                        return Container(
                          height: double.maxFinite,
                          width: MediaQuery.of(context).size.width * 0.40,
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
                      width: MediaQuery.of(context).size.width * 0.40,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(4.0, 8.0, 8.0, 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          courseList[index].title,
                          style: const TextStyle(
                            fontSize: 15.0,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          courseList[index].channelName,
                          style: TextStyle(
                            fontSize: 10.0,
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white54 : Colors.black45,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        RatingBarIndicator(
                          rating: double.parse(courseList[index].rating),
                          itemBuilder: (context, index) => const Icon(
                            Icons.star_rate_rounded,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 12.0,
                          direction: Axis.horizontal,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.person,
                              size: 12.0,
                              color: Theme.of(context).brightness == Brightness.dark ? Colors.white54 : Colors.black45,
                            ),
                            const SizedBox(width: 5.0),
                            Text(
                              int.parse(courseList[index].studentEnrolled) >= 2 ? "${courseList[index].studentEnrolled} students" : "${courseList[index].studentEnrolled} student",
                              style: TextStyle(
                                fontSize: 10.0,
                                color: Theme.of(context).brightness == Brightness.dark ? Colors.white54 : Colors.black45,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
