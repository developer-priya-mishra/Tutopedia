import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tutopedia/components/loading_dialog.dart';
import 'package:tutopedia/components/shimmer_box.dart';
import 'package:tutopedia/constants/hive_boxes.dart';
import 'package:tutopedia/constants/styling.dart';
import 'package:tutopedia/models/course_model.dart';
import 'package:tutopedia/screens/course_screen.dart';
import 'package:tutopedia/screens/search_course_screen.dart';
import 'package:tutopedia/screens/signin_screen.dart';
import 'package:tutopedia/services/api_service.dart';

class CoursePreviewScreen extends StatefulWidget {
  final CourseModel course;
  const CoursePreviewScreen({super.key, required this.course});

  @override
  State<CoursePreviewScreen> createState() => _CoursePreviewScreenState();
}

class _CoursePreviewScreenState extends State<CoursePreviewScreen> {
  bool isLoading = false;

  bool isEnrolled = false;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: myCoursesBox.listenable(),
      builder: (context, value, child) {
        if (myCoursesBox.containsKey(widget.course.id)) {
          Future.delayed(
            const Duration(seconds: 1),
            () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => CourseScreen(
                    course: widget.course,
                    currentUserRating: myCoursesBox.get(widget.course.id),
                  ),
                ),
              );
            },
          );
        }
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
              "Details",
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
            child: ListView(
              children: [
                CachedNetworkImage(
                  imageUrl: "https://i.ytimg.com/vi/${widget.course.link.substring(30, 41)}/maxresdefault.jpg",
                  placeholder: (context, url) {
                    return ShimmerBox(
                      height: MediaQuery.of(context).size.width / (16 / 9),
                      width: MediaQuery.of(context).size.width,
                      borderRadius: 0.0,
                      margin: 0.0,
                    );
                  },
                  errorWidget: (context, url, error) {
                    return Container(
                      height: MediaQuery.of(context).size.width / (16 / 9),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
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
                const SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    widget.course.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                const SizedBox(height: 5.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    widget.course.channelName,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.white54 : Colors.black45,
                    ),
                  ),
                ),
                const SizedBox(height: 15.0),
              ],
            ),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 50.0,
              width: MediaQuery.of(context).size.width,
              child: TextButton(
                onPressed: () {
                  if (authInfoBox.get("authToken").isEmpty) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SigninScreen(),
                      ),
                    );
                  } else {
                    if (!isLoading) {
                      setState(() {
                        isLoading = true;
                      });
                      LoadingDialog(context);

                      ApiService()
                          .addCourse(
                        id: widget.course.id,
                        token: authInfoBox.get("authToken"),
                      )
                          .then((value) {
                        setState(() {
                          isLoading = false;
                        });
                        Navigator.pop(context);
                        if (value["success"] == "Course Add Successfully To My Course" || value["error"] == "Already Add To My Course") {
                          myCoursesBox.put(widget.course.id, 0.0);

                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => CourseScreen(
                                course: widget.course,
                                currentUserRating: myCoursesBox.get(widget.course.id),
                              ),
                            ),
                          );
                        }
                      }).onError((error, stackTrace) {
                        setState(() {
                          isLoading = false;
                        });
                        Navigator.pop(context);
                      });
                    }
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(primaryColor),
                ),
                child: Text(
                  isEnrolled ? "Unenroll" : "Enroll",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}
