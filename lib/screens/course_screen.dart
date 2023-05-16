import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pod_player/pod_player.dart';
import 'package:tutopedia/components/loading_dialog.dart';
import 'package:tutopedia/constants/hive_boxes.dart';
import 'package:tutopedia/constants/styling.dart';
import 'package:tutopedia/models/course_model.dart';
import 'package:tutopedia/screens/course_preview_screen.dart';
import 'package:tutopedia/services/api_service.dart';

class CourseScreen extends StatefulWidget {
  final CourseModel course;
  final double currentUserRating;

  const CourseScreen({
    super.key,
    required this.course,
    required this.currentUserRating,
  });

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  int currentLectureIndex = 0;

  bool isLoading = false;

  late PodPlayerController ytPlayerController;

  @override
  void initState() {
    ytPlayerController = PodPlayerController(
      playVideoFrom: PlayVideoFrom.youtube('https://youtu.be/${widget.course.link.substring(30, 41)}'),
      podPlayerConfig: const PodPlayerConfig(
        autoPlay: false,
      ),
    )..initialise();

    super.initState();
  }

  @override
  void dispose() {
    ytPlayerController.dispose();
    super.dispose();
  }

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
              if (!isLoading) {
                setState(() {
                  isLoading = true;
                });
                LoadingDialog(context);

                ApiService()
                    .deleteCourse(
                  id: widget.course.id,
                  token: authInfoBox.get("authToken"),
                )
                    .then((value) {
                  setState(() {
                    isLoading = false;
                  });
                  Navigator.pop(context);

                  if (value["success"] == "MyCourse Removed Successfully" || value["message"] == "Call to a member function delete() on null") {
                    myCoursesBox.delete(widget.course.id);

                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => CoursePreviewScreen(
                          course: widget.course,
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
            },
            icon: Icon(
              Icons.bookmark_added,
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
              size: 25.0,
            ),
            splashRadius: 25.0,
            tooltip: "Disenroll",
          ),
        ],
      ),
      body: SafeArea(
        child: widget.course.lectureList.isEmpty
            ? SizedBox(
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
              )
            : Column(
                children: [
                  PodVideoPlayer(
                    controller: ytPlayerController,
                    videoThumbnail: DecorationImage(
                      image: NetworkImage(
                        "https://i.ytimg.com/vi/${widget.course.link.substring(30, 41)}/maxresdefault.jpg",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        const SizedBox(height: 15.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  onPressed: () async {
                                    if (widget.course.lectureList.length > 1) {
                                      if (currentLectureIndex > 0) {
                                        currentLectureIndex = currentLectureIndex - 1;
                                        await ytPlayerController
                                            .changeVideo(
                                              playVideoFrom: PlayVideoFrom.youtube(
                                                'https://youtu.be/${widget.course.lectureList[currentLectureIndex].link.substring(30, 41)}',
                                              ),
                                            )
                                            .then(
                                              (value) => setState(() {}),
                                            );
                                      }
                                    }
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(primaryColor),
                                  ),
                                  child: const Text(
                                    "Previous",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15.0),
                              Expanded(
                                child: TextButton(
                                  onPressed: () async {
                                    if (widget.course.lectureList.length > 1) {
                                      if (currentLectureIndex < widget.course.lectureList.length - 1) {
                                        currentLectureIndex = currentLectureIndex + 1;
                                        await ytPlayerController
                                            .changeVideo(
                                              playVideoFrom: PlayVideoFrom.youtube(
                                                'https://youtu.be/${widget.course.lectureList[currentLectureIndex].link.substring(30, 41)}',
                                              ),
                                            )
                                            .then(
                                              (value) => setState(() {}),
                                            );
                                      }
                                    }
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(primaryColor),
                                  ),
                                  child: const Text(
                                    "Next",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text(
                            widget.course.lectureList[currentLectureIndex].title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.course.channelName,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white54 : Colors.black45,
                                ),
                              ),
                              RatingBar(
                                initialRating: widget.currentUserRating,
                                allowHalfRating: true,
                                glowColor: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
                                itemSize: 25.0,
                                ratingWidget: RatingWidget(
                                  full: const Icon(
                                    Icons.star_rate_rounded,
                                    color: Colors.amber,
                                  ),
                                  half: const Icon(
                                    Icons.star_half_rounded,
                                    color: Colors.amber,
                                  ),
                                  empty: const Icon(
                                    Icons.star_border_rounded,
                                    color: Colors.amber,
                                  ),
                                ),
                                onRatingUpdate: (rating) {
                                  if (!isLoading) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    LoadingDialog(context);
                                    ApiService()
                                        .rateCourse(
                                      rating: rating,
                                      courseId: widget.course.id,
                                      token: authInfoBox.get("authToken"),
                                    )
                                        .then((value) {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      Navigator.pop(context);
                                      if (value["success"] == "rated successfully" || value["success"] == "rating updated successfully ") {
                                        myCoursesBox.put(widget.course.id, rating);

                                        Fluttertoast.showToast(
                                          msg: "Successfully rated the course.",
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: primaryColor.shade500,
                                          textColor: Colors.white,
                                          fontSize: 16.0,
                                        );
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text("Something went wrong"),
                                            content: const Text("Unable to rate the course, please try again."),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("Okay"),
                                              )
                                            ],
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(25.0),
                                            ),
                                            actionsPadding: const EdgeInsets.only(bottom: 12.0, right: 15.0),
                                          ),
                                        );
                                      }
                                    }).onError((error, stackTrace) {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      Navigator.pop(context);
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text("Got some error"),
                                          content: const Text("Unable to rate the course, please try again."),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("Okay"),
                                            )
                                          ],
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25.0),
                                          ),
                                          actionsPadding: const EdgeInsets.only(bottom: 12.0, right: 15.0),
                                        ),
                                      );
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.access_time_rounded, size: 15.0),
                                  const SizedBox(width: 5.0),
                                  Text(
                                    widget.course.lectureList[currentLectureIndex].time,
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_month_rounded, size: 15.0),
                                  const SizedBox(width: 5.0),
                                  Text(
                                    "${DateTime.parse(widget.course.lectureList[currentLectureIndex].updatedAt).day.toString()}.${DateTime.parse(widget.course.lectureList[currentLectureIndex].updatedAt).month.toString()}.${DateTime.parse(widget.course.lectureList[currentLectureIndex].updatedAt).year.toString()}",
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text(
                            widget.course.lectureList[currentLectureIndex].description,
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black45,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text(
                            "Lectures",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        ...widget.course.lectureList.map((item) {
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 15.0,
                              vertical: 5.0,
                            ),
                            color: widget.course.lectureList[currentLectureIndex] == item
                                ? primaryColor.shade100
                                : Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey.shade800
                                    : Colors.grey.shade200,
                            elevation: 0.0,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(50.0),
                              ),
                            ),
                            child: InkWell(
                              onTap: () async {
                                currentLectureIndex = widget.course.lectureList.indexOf(item);
                                await ytPlayerController
                                    .changeVideo(
                                      playVideoFrom: PlayVideoFrom.youtube(
                                        'https://youtu.be/${widget.course.lectureList[currentLectureIndex].link.substring(30, 41)}',
                                      ),
                                    )
                                    .then(
                                      (value) => setState(() {}),
                                    );
                              },
                              borderRadius: const BorderRadius.all(
                                Radius.circular(50.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0,
                                  vertical: 10.0,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(5.0),
                                      decoration: BoxDecoration(
                                        color: widget.course.lectureList[currentLectureIndex] == item ? primaryColor : primaryColor.shade100,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        widget.course.lectureList[currentLectureIndex] == item ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                        size: 22.0,
                                        color: widget.course.lectureList[currentLectureIndex] == item ? Colors.white : primaryColor,
                                      ),
                                    ),
                                    const SizedBox(width: 10.0),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Lecture ${widget.course.lectureList.indexOf(item) + 1}",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: Theme.of(context).brightness == Brightness.dark
                                                  ? widget.course.lectureList[currentLectureIndex] == item
                                                      ? Colors.black87
                                                      : Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 2.5),
                                          Text(
                                            item.title,
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              color: Theme.of(context).brightness == Brightness.dark
                                                  ? widget.course.lectureList[currentLectureIndex] == item
                                                      ? Colors.black54
                                                      : Colors.white54
                                                  : Colors.black45,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: 15.0),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
