class ApiUrl {
  static Uri baseUrl = Uri.parse(
    "https://sagecrm.thesagenext.com",
  );

  static Uri signUpApi = Uri.parse(
    "${baseUrl.toString()}/tutoapi/api/register",
  );

  static Uri signInApi = Uri.parse(
    "${baseUrl.toString()}/tutoapi/api/login",
  );

  static Uri signOutApi = Uri.parse(
    "${baseUrl.toString()}/tutoapi/api/logout",
  );

  static Uri changePasswordApi = Uri.parse(
    "${baseUrl.toString()}/tutoapi/api/forgetPassword/otp/changePassword",
  );

  static Uri forgotPasswordApi = Uri.parse(
    "${baseUrl.toString()}/tutoapi/api/forgetPassword",
  );

  static Uri verifyEmailApi = Uri.parse(
    "${baseUrl.toString()}/tutoapi/api/forgetPassword/otp",
  );

  static Uri changeProfilePhotoApi = Uri.parse(
    "${baseUrl.toString()}/tutoapi/api/profile",
  );

  static Uri mainCategoriesApi = Uri.parse(
    "${baseUrl.toString()}/tutoapi/api/category",
  );

  static Uri subCategoriesApi = Uri.parse(
    "${baseUrl.toString()}/tutoapi/api/subcategory",
  );

  static Uri topicListApi = Uri.parse(
    "${baseUrl.toString()}/tutoapi/api/courses",
  );

  static Uri coursesByTopicIdApi = Uri.parse(
    "${baseUrl.toString()}/tutoapi/api/channel",
  );

  static Uri topRatedCoursesApi = Uri.parse(
    "${baseUrl.toString()}/tutoapi/api/toprated",
  );

  static Uri trendingTopicsApi = Uri.parse(
    "${baseUrl.toString()}/tutoapi/api/trends",
  );

  static Uri newCoursesApi = Uri.parse(
    "${baseUrl.toString()}/tutoapi/api/newChannel",
  );

  static Uri popularCoursesApi = Uri.parse(
    "${baseUrl.toString()}/tutoapi/api/mostpopular",
  );

  static Uri myCoursesApi = Uri.parse(
    "${baseUrl.toString()}/tutoapi/api/my/course",
  );

  static Uri addCourseApi = Uri.parse(
    "${baseUrl.toString()}/tutoapi/api/my/course",
  );

  static Uri deleteCourseApi = Uri.parse(
    "${baseUrl.toString()}/tutoapi/api/remove/my/course",
  );

  static Uri rateCourseApi = Uri.parse(
    "${baseUrl.toString()}/tutoapi/api/channel/rating",
  );
}
