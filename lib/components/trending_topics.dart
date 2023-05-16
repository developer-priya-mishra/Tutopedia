import 'package:flutter/material.dart';
import 'package:tutopedia/components/shimmer_box.dart';
import 'package:tutopedia/constants/styling.dart';
import 'package:tutopedia/models/topic_model.dart';
import 'package:tutopedia/screens/course_list_screen.dart';

class TrendingTopics extends StatelessWidget {
  final List<TopicModel> topicList;
  const TrendingTopics(this.topicList, {super.key});

  @override
  Widget build(BuildContext context) {
    if (topicList.isNotEmpty) {
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: topicList.map((item) {
            return InkWell(
              borderRadius: const BorderRadius.all(
                Radius.circular(50.0),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CourseListScreen(
                      topic: item,
                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.all(3.25),
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                alignment: Alignment.center,
                constraints: const BoxConstraints(minWidth: 150.0),
                height: 40.0,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(50.0),
                  ),
                  color: primaryColor.shade50,
                ),
                child: Text(
                  item.title,
                  style: const TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    } else {
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.filled(5, 0).map((item) {
            return const ShimmerBox(
              height: 40.0,
              width: 150.0,
              borderRadius: 50.0,
              margin: 3.25,
            );
          }).toList(),
        ),
      );
    }
  }
}
