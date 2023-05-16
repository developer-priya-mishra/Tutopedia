import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tutopedia/components/course_view.dart';
import 'package:tutopedia/constants/hive_boxes.dart';
import 'package:tutopedia/constants/styling.dart';
import 'package:tutopedia/models/course_model.dart';
import 'package:tutopedia/screens/signin_screen.dart';

class MyCourseList extends StatelessWidget {
  final List<CourseModel> courseList;
  final bool isLoading;
  const MyCourseList({
    super.key,
    required this.courseList,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: authInfoBox.listenable(),
      builder: (context, authInfoBox, child) {
        if (authInfoBox.get("authToken").isEmpty) {
          return SizedBox(
            height: MediaQuery.of(context).size.height - 305.0,
            width: MediaQuery.of(context).size.width,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SigninScreen(),
                  ),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/svg/authentication.svg',
                    width: MediaQuery.of(context).size.width * 0.80,
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    "Sigin to view my courses",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        } else {
          if (isLoading) {
            return SizedBox(
              height: MediaQuery.of(context).size.height - 305.0,
              width: MediaQuery.of(context).size.width,
              child: const SpinKitThreeInOut(
                color: primaryColor,
                size: 50.0,
              ),
            );
          } else if (courseList.isNotEmpty) {
            return CourseView(
              courseList: courseList,
              shrinkWrap: true,
            );
          } else {
            return SizedBox(
              height: MediaQuery.of(context).size.height - 305.0,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/svg/no_data.svg',
                    width: MediaQuery.of(context).size.width * 0.70,
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    "Sorry, no enrolled courses found",
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
        }
      },
    );
  }
}
