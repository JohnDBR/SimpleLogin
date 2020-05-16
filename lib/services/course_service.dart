import 'package:login_flutter/models/course_info.dart';
import '../locator.dart';
import 'api.dart';

class CourseService {
  Api _api = locator<Api>();

  // String _user;
  // String _token;
  List<CourseInfo> _courses;
  List<CourseInfo> get courses => _courses;

  Future getCourses({String username, String token}) async {
    // _user = username;
    // _token = token;
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

} 