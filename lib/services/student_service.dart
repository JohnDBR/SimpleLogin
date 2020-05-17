import 'package:login_flutter/models/student_info.dart';
import '../locator.dart';
import 'api.dart';

class StudentService {
  Api _api = locator<Api>();

  List<StudentInfo> _students;
  StudentInfo _student;

  List<StudentInfo> get students => _students;
  StudentInfo get student => _student;

  Future getStudents({String username, String token}) async {
    try {
      _students = await _api.getStudents(token: token, username: username);
    } catch (err) {
      print('service getStudents ${err.toString()}');
      return Future.error(err.toString());
    }
  }

  Future addStudent({String username, String token, String courseId}) async {
    try {
      StudentInfo student = await _api.createStudent(token: token, username: username, courseId: courseId);
      _students.add(student);
    } catch (err) {
      print('service addStudent ${err.toString()}');
      return Future.error(err.toString());
    }
  }

  Future showStudent({String username, String token, String studentId}) async {
    try {
      _student = await _api.showStudent(token: token, username: username, studentId: studentId);
    } catch (err) {
      print('service showStudent ${err.toString()}');
      return Future.error(err.toString());
    }
  }
} 