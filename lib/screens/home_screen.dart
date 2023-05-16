import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tutopedia/components/main_categories.dart';
import 'package:tutopedia/components/header.dart';
import 'package:tutopedia/components/loading_dialog.dart';
import 'package:tutopedia/components/mycourse_list.dart';
import 'package:tutopedia/components/new_courses.dart';
import 'package:tutopedia/components/popular_courses.dart';
import 'package:tutopedia/components/theme_changer.dart';
import 'package:tutopedia/components/top_rated_courses.dart';
import 'package:tutopedia/components/trending_topics.dart';
import 'package:tutopedia/constants/app_info.dart';
import 'package:tutopedia/constants/hive_boxes.dart';
import 'package:tutopedia/constants/styling.dart';
import 'package:tutopedia/models/course_model.dart';
import 'package:tutopedia/models/main_category_model.dart';
import 'package:tutopedia/models/topic_model.dart';
import 'package:tutopedia/screens/change_password_screen.dart';
import 'package:tutopedia/screens/search_course_screen.dart';
import 'package:tutopedia/screens/signin_screen.dart';
import 'package:tutopedia/services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CourseModel> popularCourses = [];
  List<MainCategoryModel> mainCategories = [];
  List<CourseModel> topRatedCourses = [];
  List<TopicModel> trendingTopics = [];
  List<CourseModel> newCourses = [];
  List<CourseModel> myCourses = [];

  int totalMyCourses = 0;

  int currentIndex = 0;

  bool isLoading = false;

  String appName = "Tutopedia";
  String appVersion = "";

  @override
  void initState() {
    totalMyCourses = myCoursesBox.length;

    PackageInfo.fromPlatform().then((info) {
      setState(() {
        appName = info.appName;
        appVersion = info.version;
      });
    });

    getAllData();

    getAllMyCourses();

    super.initState();
  }

  Future<void> getAllData() async {
    getAllPopularCourses();
    getAllMainCategories();
    getAllTopRatedCourses();
    getAllTrendingTopics();
    await getAllNewCourses();
  }

  Future<void> getAllPopularCourses() async {
    try {
      popularCourses = await ApiService().popularCourseList();
    } catch (e) {
      popularCourses = [];
    }
    setState(() {});
  }

  Future<void> getAllMainCategories() async {
    try {
      mainCategories = await ApiService().mainCategories();
    } catch (e) {
      mainCategories = [];
    }
    setState(() {});
  }

  Future<void> getAllTopRatedCourses() async {
    try {
      topRatedCourses = await ApiService().topRatedCourseList();
    } catch (e) {
      topRatedCourses = [];
    }
    setState(() {});
  }

  Future<void> getAllTrendingTopics() async {
    try {
      trendingTopics = await ApiService().trendingTopics();
    } catch (e) {
      trendingTopics = [];
    }
    setState(() {});
  }

  Future<void> getAllNewCourses() async {
    try {
      newCourses = await ApiService().newCourseList();
    } catch (e) {
      newCourses = [];
    }
    setState(() {});
  }

  Future<void> getAllMyCourses() async {
    Future.delayed(
      const Duration(seconds: 1),
      () {
        setState(() {
          isLoading = true;
        });
      },
    );
    try {
      myCourses = await ApiService().myCourses(authInfoBox.get("authToken"));
    } catch (e) {
      myCourses = [];
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    appLogBox.close();
    authInfoBox.close();
    myCoursesBox.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: authInfoBox.listenable(),
      builder: (context, authInfoBox, child) {
        return Scaffold(
          drawer: Drawer(
            child: Column(
              children: [
                const SizedBox(height: 50.0),
                Container(
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      authInfoBox.get("profilePhoto").isEmpty
                          ? const CircleAvatar(
                              radius: 70.0,
                              backgroundImage: AssetImage(
                                "assets/images/avatar.png",
                              ),
                            )
                          : CircleAvatar(
                              radius: 70.0,
                              backgroundImage: NetworkImage(
                                "https://sagecrm.thesagenext.com/tutoapi/${authInfoBox.get("profilePhoto")}",
                              ),
                            ),
                      authInfoBox.get("authToken").isEmpty
                          ? const SizedBox()
                          : Positioned(
                              bottom: 0,
                              right: 0,
                              child: IconButton(
                                onPressed: () {
                                  final ImagePicker picker = ImagePicker();
                                  picker
                                      .pickImage(source: ImageSource.gallery)
                                      .then((image) {
                                    if (image != null) {
                                      if (!isLoading) {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        LoadingDialog(context);
                                        ApiService()
                                            .changeProfilePhoto(
                                          imagePath: image.path,
                                          token: authInfoBox.get("authToken"),
                                        )
                                            .then((value) {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          Navigator.pop(context);
                                          if (value["success"] ==
                                              "profile-updated") {
                                            authInfoBox.put('profilePhoto',
                                                value["profile_image"]);
                                            Fluttertoast.showToast(
                                              msg:
                                                  "Successfully updated the profile photo.",
                                              gravity: ToastGravity.BOTTOM,
                                              backgroundColor:
                                                  primaryColor.shade500,
                                              textColor: Colors.white,
                                              fontSize: 16.0,
                                            );
                                          } else {
                                            Fluttertoast.showToast(
                                              msg:
                                                  "Sorry, unable to update profile photo.",
                                              gravity: ToastGravity.BOTTOM,
                                              backgroundColor:
                                                  primaryColor.shade500,
                                              textColor: Colors.white,
                                              fontSize: 16.0,
                                            );
                                          }
                                        }).onError((error, stackTrace) {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          Navigator.pop(context);
                                          Fluttertoast.showToast(
                                            msg:
                                                "Error, unable to update profile photo.",
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor:
                                                primaryColor.shade500,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                        });
                                      }
                                    } else {
                                      Fluttertoast.showToast(
                                        msg: "Please choose a profile photo.",
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: primaryColor.shade500,
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );
                                    }
                                  });
                                },
                                icon: const Icon(Icons.edit_rounded),
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all(primaryColor),
                                  backgroundColor: MaterialStateProperty.all(
                                    Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.grey.shade300
                                        : Colors.white,
                                  ),
                                ),
                                tooltip: "Choose Image",
                              ),
                            ),
                    ],
                  ),
                ),
                authInfoBox.get("authToken").isEmpty
                    ? const SizedBox(height: 5.0)
                    : const SizedBox(height: 15.0),
                authInfoBox.get("authToken").isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: TextButton(
                          onPressed: () {
                            if (authInfoBox.get("authToken").isEmpty) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const SigninScreen(),
                                ),
                              );
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(primaryColor),
                          ),
                          child: const Text(
                            "Signin",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
                // username
                authInfoBox.get("authToken").isEmpty
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          authInfoBox.get("name"),
                          style: const TextStyle(
                            fontFamily: secondaryFont,
                            fontSize: 30.0,
                            color: primaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                authInfoBox.get("authToken").isEmpty
                    ? const SizedBox()
                    : const SizedBox(height: 5.0),
                // email
                authInfoBox.get("authToken").isEmpty
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          authInfoBox.get("email"),
                          style: TextStyle(
                            fontSize: 18.0,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white54
                                    : Colors.black45,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                authInfoBox.get("authToken").isEmpty
                    ? const SizedBox()
                    : const SizedBox(height: 15.0),
                // change password
                authInfoBox.get("authToken").isEmpty
                    ? const SizedBox()
                    : ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ChangePasswordScreen(),
                            ),
                          );
                        },
                        leading: Icon(
                          Icons.password_rounded,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                        title: const Text(
                          "Change Password",
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                ListTile(
                  onTap: () {
                    AdaptiveThemeMode currentThemeMode =
                        AdaptiveTheme.of(context).mode;
                    ThemeChange(context, currentThemeMode);
                  },
                  leading: Icon(
                    Icons.palette_outlined,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                  title: const Text(
                    "Theme",
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Share.share(
                        'Check out Tutopedia, a learning app for students.\nDownload now: $appLink');
                  },
                  leading: Icon(
                    Icons.share,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                  title: const Text(
                    "Share",
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ),
                // signout
                authInfoBox.get("authToken").isEmpty
                    ? const SizedBox()
                    : ListTile(
                        onTap: () {
                          if (!isLoading) {
                            setState(() {
                              isLoading = true;
                            });
                            LoadingDialog(context);
                            ApiService()
                                .signOut(authInfoBox.get("authToken"))
                                .then((value) {
                              setState(() {
                                isLoading = false;
                              });
                              Navigator.pop(context);
                              if (value["success"] ==
                                  "logged out successfully") {
                                authInfoBox.put('name', "");
                                authInfoBox.put('email', "");
                                authInfoBox.put('profilePhoto', "");
                                authInfoBox.put('authToken', "");

                                myCoursesBox.deleteAll(myCoursesBox.keys);

                                Fluttertoast.showToast(
                                  msg: "Your are successfully sign out.",
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
                                    content: const Text(
                                        "Unable to sign out, please try again."),
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
                                    actionsPadding: const EdgeInsets.only(
                                        bottom: 12.0, right: 15.0),
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
                                  title: const Text("Something went wrong"),
                                  content: const Text(
                                      "Unable to sign in, please try again."),
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
                                  actionsPadding: const EdgeInsets.only(
                                      bottom: 12.0, right: 15.0),
                                ),
                              );
                            });
                          }
                        },
                        leading: Icon(
                          Icons.login_rounded,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                        title: const Text(
                          "Signout",
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                ListTile(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        icon: CircleAvatar(
                          radius: 50.0,
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(25.0)),
                            child: Image.asset(
                              "assets/images/app_icon.png",
                            ),
                          ),
                        ),
                        title: Text(appName),
                        content: const Text(
                          "Tutopedia is online e-learning platform for students.",
                          textAlign: TextAlign.center,
                        ),
                        iconPadding:
                            const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0.0),
                        titlePadding:
                            const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
                        contentPadding: const EdgeInsets.all(15.0),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Close"),
                          )
                        ],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        actionsPadding:
                            const EdgeInsets.only(bottom: 12.0, right: 15.0),
                      ),
                    );
                  },
                  leading: Icon(
                    Icons.info_outline_rounded,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                  title: const Text(
                    "About Us",
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    alignment: Alignment.bottomCenter,
                    child: Text(appVersion),
                  ),
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: WillPopScope(
              onWillPop: () async {
                var result = await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Do you want to exit?"),
                      actions: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: const Text("No"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              primaryColor,
                            ),
                            foregroundColor: MaterialStateProperty.all(
                              Colors.white,
                            ),
                          ),
                          child: const Text("Yes"),
                        ),
                      ],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      actionsPadding:
                          const EdgeInsets.only(bottom: 12.0, right: 15.0),
                    );
                  },
                );
                return result;
              },
              child: RefreshIndicator(
                onRefresh: () {
                  if (currentIndex == 0) {
                    popularCourses = [];
                    mainCategories = [];
                    topRatedCourses = [];
                    trendingTopics = [];
                    newCourses = [];
                    setState(() {});
                    return getAllData();
                  } else {
                    return getAllMyCourses();
                  }
                },
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: authInfoBox.get("name").isEmpty
                                  ? "Welcome"
                                  : "Hi, ${authInfoBox.get("name").split(" ")[0]}",
                              style: TextStyle(
                                fontFamily: secondaryFont,
                                fontSize: 30.0,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              children: [
                                TextSpan(
                                  text: "\nWhat do you wanna learn today?",
                                  style: TextStyle(
                                    fontFamily: primaryFont,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white60
                                        : Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            maxLines: 2,
                          ),
                          Builder(builder: (context) {
                            return GestureDetector(
                              onTap: () {
                                Scaffold.of(context).openDrawer();
                              },
                              child: authInfoBox.get("profilePhoto").isEmpty
                                  ? const CircleAvatar(
                                      radius: 25,
                                      backgroundImage: AssetImage(
                                        "assets/images/avatar.png",
                                      ),
                                    )
                                  : CircleAvatar(
                                      radius: 25.0,
                                      backgroundImage: NetworkImage(
                                        "https://sagecrm.thesagenext.com/tutoapi/${authInfoBox.get("profilePhoto")}",
                                      ),
                                    ),
                            );
                          }),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showSearch(
                            context: context, delegate: SearchCourseScreen());
                      },
                      child: Container(
                        margin: const EdgeInsets.all(15.0),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15.0,
                          vertical: 10.0,
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor.shade50,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50.0)),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Search",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black45,
                              ),
                            ),
                            Icon(
                              Icons.search_rounded,
                              color: Colors.black45,
                              size: 30.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    currentIndex == 0
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Header(title: 'Most Popular Courses'),
                              PopularCourses(popularCourses),
                              const SizedBox(height: 15.0),
                              const Header(title: 'Categories'),
                              MainCategories(mainCategories),
                              const SizedBox(height: 15.0),
                              const Header(title: 'Top Rated Courses'),
                              TopRatedCourses(topRatedCourses),
                              const SizedBox(height: 15.0),
                              const Header(title: 'Trending topics'),
                              TrendingTopics(trendingTopics),
                              const SizedBox(height: 15.0),
                              const Header(title: 'New Courses'),
                              NewCourses(newCourses),
                            ],
                          )
                        : ValueListenableBuilder(
                            valueListenable: myCoursesBox.listenable(),
                            builder: (context, updatedMyCoursesBox, child) {
                              if (updatedMyCoursesBox.length !=
                                  totalMyCourses) {
                                getAllMyCourses();
                                totalMyCourses = updatedMyCoursesBox.length;
                              }
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        15.0, 15.0, 15.0, 0.0),
                                    child: SizedBox(
                                      child: Text(
                                        "Your enrolled courses ${updatedMyCoursesBox.isEmpty ? "" : "(${updatedMyCoursesBox.length})"}",
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  MyCourseList(
                                    courseList: myCourses,
                                    isLoading: isLoading,
                                  ),
                                ],
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: SalomonBottomBar(
            currentIndex: currentIndex,
            onTap: (i) {
              if (i == 1) {
                if (authInfoBox.get("authToken").isEmpty) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SigninScreen(),
                    ),
                  );
                } else {
                  setState(() {
                    currentIndex = i;
                  });
                }
              } else {
                setState(() {
                  currentIndex = i;
                });
              }
            },
            items: [
              SalomonBottomBarItem(
                icon: const Icon(Icons.home_outlined),
                activeIcon: const Icon(Icons.home_rounded),
                title: const Text("Home"),
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.book_outlined),
                activeIcon: const Icon(Icons.book_rounded),
                title: const Text("My Courses"),
              ),
            ],
          ),
        );
      },
    );
  }
}
