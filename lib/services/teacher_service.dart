import 'package:login_flutter/models/teacher_info.dart';
import '../locator.dart';
import 'api.dart';

class TeacherService {
  Api _api = locator<Api>();

  List<TeacherInfo> _teachers;
  TeacherInfo _teacher;

  List<TeacherInfo> get teachers => _teachers;
  TeacherInfo get teacher => _teacher;

  Future getTeachers({String username, String token}) async {
    try {
      _teachers = await _api.getTeachers(token: token, username: username);
    } catch (err) {
      print('service getTeachers ${err.toString()}');
      return Future.error(err.toString());
    }
  }

  Future showTeacher({String username, String token, String teacherId}) async {
    try {
      _teacher = await _api.showTeacher(token: token, username: username, teacherId: teacherId);
    } catch (err) {
      print('service showTeacher ${err.toString()}');
      return Future.error(err.toString());
    }
  }
} 