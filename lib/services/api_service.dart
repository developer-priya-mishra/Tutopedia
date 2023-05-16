import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tutopedia/constants/api_url.dart';
import 'package:tutopedia/models/topic_model.dart';
import 'package:tutopedia/models/course_model.dart';
import 'package:tutopedia/models/main_category_model.dart';
import 'package:tutopedia/models/sub_category_model.dart';

class ApiService {
  Future<dynamic> signup({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      var response = await http.post(
        ApiUrl.signUpApi,
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({"name": name, "email": email, "password": password, "c_password": confirmPassword}),
      );
      return json.decode(response.body);
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> signin({
    required String email,
    required String password,
  }) async {
    try {
      var response = await http.post(
        ApiUrl.signInApi,
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );
      return json.decode(response.body);
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> signOut(String token) async {
    try {
      var response = await http.post(
        ApiUrl.signOutApi,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return json.decode(response.body);
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> changePassword({
    required String password,
    required String confirmPassword,
    required String token,
  }) async {
    try {
      var response = await http.post(
        ApiUrl.changePasswordApi,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "new_password": password,
          "confirm_password": confirmPassword,
        }),
      );

      return json.decode(response.body);
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> forgotPassword(String email) async {
    try {
      var response = await http.post(
        ApiUrl.forgotPasswordApi,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "email": email,
        }),
      );

      return json.decode(response.body);
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> verifyEmail({
    required String otp,
    required String token,
  }) async {
    try {
      var response = await http.post(
        ApiUrl.verifyEmailApi,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "otp": otp,
        }),
      );

      return json.decode(response.body);
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> changeProfilePhoto({
    required String imagePath,
    required String token,
  }) async {
    var headersList = {'Accept': 'application/json', 'Authorization': 'Bearer $token'};
    var url = ApiUrl.changeProfilePhotoApi;

    var req = http.MultipartRequest('POST', url);
    req.headers.addAll(headersList);
    req.files.add(await http.MultipartFile.fromPath('profile_image', imagePath));

    var res = await req.send();

    final resBody = await res.stream.bytesToString();

    return json.decode(resBody);
  }

  Future<List<MainCategoryModel>> mainCategories() async {
    var response = await http.get(
      ApiUrl.mainCategoriesApi,
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    );

    List<MainCategoryModel> mainCategoryList = [];

    try {
      List body = json.decode(response.body);

      for (var category in body) {
        mainCategoryList.add(MainCategoryModel.fromJson(category));
      }

      return mainCategoryList;
    } catch (e) {
      return mainCategoryList;
    }
  }

  Future<List<SubCategoryModel>> subCategories(String id) async {
    var response = await http.get(
      Uri.parse(
        "${ApiUrl.subCategoriesApi.toString()}/$id",
      ),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    );

    List<SubCategoryModel> subCategoryList = [];

    try {
      List body = json.decode(response.body);

      for (var category in body) {
        subCategoryList.add(SubCategoryModel.fromJson(category));
      }

      return subCategoryList;
    } catch (e) {
      return subCategoryList;
    }
  }

  Future<List<TopicModel>> topicList(String id) async {
    var response = await http.get(
      Uri.parse(
        "${ApiUrl.topicListApi.toString()}/$id",
      ),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    );

    List<TopicModel> topicList = [];

    try {
      List body = json.decode(response.body);

      for (var topic in body) {
        topicList.add(TopicModel.fromJson(topic));
      }

      return topicList;
    } catch (e) {
      return topicList;
    }
  }

  Future<List<CourseModel>> coursesByTopicId(String id) async {
    var response = await http.get(
      Uri.parse(
        "${ApiUrl.coursesByTopicIdApi.toString()}/$id",
      ),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    List<CourseModel> courseList = [];

    try {
      List body = json.decode(response.body);

      for (var course in body) {
        courseList.add(CourseModel.fromJson(course));
      }

      return courseList;
    } catch (e) {
      return courseList;
    }
  }

  Future<List<CourseModel>> topRatedCourseList() async {
    var response = await http.get(
      ApiUrl.topRatedCoursesApi,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    List<CourseModel> topRatedcourseList = [];

    try {
      List body = json.decode(response.body);

      for (var course in body) {
        topRatedcourseList.add(CourseModel.fromJson(course));
      }

      return topRatedcourseList;
    } catch (e) {
      return topRatedcourseList;
    }
  }

  Future<List<TopicModel>> trendingTopics() async {
    var response = await http.get(
      ApiUrl.trendingTopicsApi,
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    );

    List<TopicModel> trendingtopicList = [];

    try {
      List body = json.decode(response.body);

      for (var topic in body) {
        trendingtopicList.add(TopicModel.fromJson(topic));
      }

      return trendingtopicList;
    } catch (e) {
      return trendingtopicList;
    }
  }

  Future<List<CourseModel>> newCourseList() async {
    var response = await http.get(
      ApiUrl.newCoursesApi,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    List<CourseModel> newcourseList = [];

    try {
      List body = json.decode(response.body);

      for (var course in body) {
        newcourseList.add(CourseModel.fromJson(course));
      }

      return newcourseList;
    } catch (e) {
      return newcourseList;
    }
  }

  Future<List<CourseModel>> popularCourseList() async {
    var response = await http.get(
      ApiUrl.popularCoursesApi,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    List<CourseModel> popularcourseList = [];

    try {
      List body = json.decode(response.body);

      for (var course in body) {
        popularcourseList.add(CourseModel.fromJson(course));
      }

      return popularcourseList;
    } catch (e) {
      return popularcourseList;
    }
  }

  Future<List<CourseModel>> myCourses(String token) async {
    var response = await http.get(
      ApiUrl.myCoursesApi,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    List<CourseModel> mycourseList = [];

    try {
      List body = json.decode(response.body);

      for (var mycourse in body) {
        mycourseList.add(CourseModel.fromJson(mycourse));
      }

      return mycourseList;
    } catch (e) {
      return mycourseList;
    }
  }

  Future<dynamic> addCourse({
    required String id,
    required String token,
  }) async {
    try {
      var response = await http.post(
        Uri.parse(
          "${ApiUrl.addCourseApi.toString()}/$id",
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return json.decode(response.body);
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> deleteCourse({
    required String id,
    required String token,
  }) async {
    try {
      var response = await http.delete(
        Uri.parse(
          "${ApiUrl.deleteCourseApi.toString()}/$id",
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return json.decode(response.body);
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> rateCourse({
    required double rating,
    required String courseId,
    required String token,
  }) async {
    try {
      var response = await http.post(
        ApiUrl.rateCourseApi,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "star_rated": rating,
          "channel_id": courseId,
        }),
      );

      return json.decode(response.body);
    } catch (e) {
      return null;
    }
  }
}
