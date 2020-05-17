import 'package:login_flutter/models/teacher_info.dart';
import '../locator.dart';
import 'api.dart';

class TeachersService {
  Api _api = locator<Api>();

  List<TeacherInfo> _courses;
  List<TeacherInfo> get teachers => _teachers;

  Future getTeachers({String username, String token}) async {
    try {
      _courses = await _api.getTeachers(token: token, username: username);
    } catch (err) {
      print('service getCourses ${err.toString()}');
      return Future.error(err.toString());
    }
  }

  Future addCourse({String username, String token}) async {
    try {
      TeacherInfo teacher = await _api.createTeacher(token: token, username: username);
      _teachers.add(teacher);
    } catch (err) {
      print('service getTeacher ${err.toString()}');
      return Future.error(err.toString());
    }
  }

} 