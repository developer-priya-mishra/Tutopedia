import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tutopedia/components/course_view.dart';
import 'package:tutopedia/constants/styling.dart';
import 'package:tutopedia/models/topic_model.dart';
import 'package:tutopedia/screens/search_course_screen.dart';
import 'package:tutopedia/services/api_service.dart';

class CourseListScreen extends StatelessWidget {
  final TopicModel topic;
  const CourseListScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
            size: 22.0,
          ),
          splashRadius: 25.0,
          tooltip: "Back",
        ),
        title: Text(
          topic.title,
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchCourseScreen(),
              );
            },
            icon: Icon(
              Icons.search_rounded,
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
              size: 25.0,
            ),
            splashRadius: 25.0,
            tooltip: "Search",
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: ApiService().coursesByTopicId(topic.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                return CourseView(
                  courseList: snapshot.data!,
                  shrinkWrap: false,
                );
              } else {
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/svg/no_data.svg',
                        width: MediaQuery.of(context).size.width * 0.80,
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        "Sorry, no course found",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }
            } else if (snapshot.hasError) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/svg/error.svg',
                      width: MediaQuery.of(context).size.width * 0.90,
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      "Sorry, something went wrong!",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            } else {
              return const SpinKitThreeInOut(
                color: primaryColor,
                size: 50.0,
              );
            }
          },
        ),
      ),
    );
  }
}
