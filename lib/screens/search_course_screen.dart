import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tutopedia/components/course_view.dart';
import 'package:tutopedia/constants/hive_boxes.dart';
import 'package:tutopedia/constants/styling.dart';
import 'package:tutopedia/models/course_model.dart';
import 'package:tutopedia/screens/course_preview_screen.dart';
import 'package:tutopedia/screens/course_screen.dart';
import 'package:tutopedia/services/api_service.dart';

class SearchCourseScreen extends SearchDelegate {
  String courseId = '';

  @override
  String? get searchFieldLabel => "Search Courses";

  @override
  TextStyle? get searchFieldStyle => const TextStyle(
        fontSize: 18.0,
      );

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: const Icon(
          Icons.clear_rounded,
        ),
        tooltip: "Clear",
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(
        Icons.arrow_back_rounded,
      ),
      tooltip: "Back",
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.trim().isEmpty) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/svg/no_data.svg',
              width: MediaQuery.of(context).size.width * 0.75,
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
    } else {
      return FutureBuilder(
        future: ApiService().newCourseList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isNotEmpty) {
              List<CourseModel> searchResult = snapshot.data!.where(
                (element) {
                  if (element.title.toLowerCase().contains(query.trim().toLowerCase())) {
                    return true;
                  } else if (element.mainCategory.toLowerCase().contains(query.trim().toLowerCase())) {
                    return true;
                  } else if (element.subCategory.toLowerCase().contains(query.trim().toLowerCase())) {
                    return true;
                  } else if (element.topic.toLowerCase().contains(query.trim().toLowerCase())) {
                    return true;
                  } else {
                    return false;
                  }
                },
              ).toList();
              if (searchResult.isNotEmpty) {
                return CourseView(
                  courseList: searchResult,
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
                        width: MediaQuery.of(context).size.width * 0.75,
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
            } else {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/svg/no_data.svg',
                      width: MediaQuery.of(context).size.width * 0.75,
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
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: ApiService().newCourseList(),
      builder: (context, snapshot) {
        if (query.trim().isEmpty) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/svg/search.svg',
                  width: MediaQuery.of(context).size.width * 0.70,
                ),
                const SizedBox(height: 20.0),
                const Text(
                  "Type to search courses",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        } else if (snapshot.hasData) {
          if (snapshot.data!.isNotEmpty) {
            List<CourseModel> searchResult = snapshot.data!.where(
              (element) {
                if (element.title.toLowerCase().contains(query.trim().toLowerCase())) {
                  return true;
                } else if (element.mainCategory.toLowerCase().contains(query.trim().toLowerCase())) {
                  return true;
                } else if (element.subCategory.toLowerCase().contains(query.trim().toLowerCase())) {
                  return true;
                } else if (element.topic.toLowerCase().contains(query.trim().toLowerCase())) {
                  return true;
                } else {
                  return false;
                }
              },
            ).toList();
            if (searchResult.isNotEmpty) {
              return ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(searchResult[index].title),
                    onTap: () {
                      bool isEnrolled = false;
                      if (myCoursesBox.isNotEmpty) {
                        isEnrolled = myCoursesBox.containsKey(searchResult[index].id);
                      }
                      if (isEnrolled) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CourseScreen(
                              course: searchResult[index],
                              currentUserRating: myCoursesBox.get(searchResult[index].id),
                            ),
                          ),
                        );
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CoursePreviewScreen(
                              course: searchResult[index],
                            ),
                          ),
                        );
                      }
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemCount: searchResult.length,
              );
            } else {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/svg/no_data.svg',
                      width: MediaQuery.of(context).size.width * 0.75,
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
          } else {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/svg/no_data.svg',
                    width: MediaQuery.of(context).size.width * 0.75,
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
    );
  }
}
