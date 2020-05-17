import 'package:login_flutter/models/course_info.dart';
import '../locator.dart';
import 'api.dart';

class CourseService {
  Api _api = locator<Api>();

  List<CourseInfo> _courses;
  CourseInfo _course;

  List<CourseInfo> get courses => _courses;
  CourseInfo get course => _course;

  Future getCourses({String username, String token}) async {
    try {
      _courses = await _api.getCourses(token: token, username: username);
    } catch (err) {
      print('service getCourses ${err.toString()}');
      return Future.error(err.toString());
    }
  }

  Future addCourse({String username, String token}) async {
    try {
      CourseInfo course = await _api.createCourse(token: token, username: username);
      _courses.add(course);
    } catch (err) {
      print('service getCourses ${err.toString()}');
      return Future.error(err.toString());
    }
  }

  Future showCourse({String username, String token, String courseId}) async {
    try {
      _course = await _api.showCourse(token: token, username: username, courseId: courseId);
    } catch (err) {
      print('service showCourses ${err.toString()}');
      return Future.error(err.toString());
    }
  }
} 