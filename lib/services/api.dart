import 'package:login_flutter/models/course_info.dart';
import 'package:login_flutter/models/student_info.dart';
import 'package:login_flutter/models/teacher_info.dart';
import 'package:login_flutter/models/user_info.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// HTTP methods!
class Api {
  static const String baseUrl = 'https://movil-api.herokuapp.com';

  // AUTH!

  Future<UserInfo> signUpRequest({String email, String password, String username, String name}) async {

    final http.Response response = await http.post(
      '$baseUrl/signup',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,'password': password,'username': username,'name': name
      }),
    );

    print('${response.body}');
    print('${response.statusCode}');
    if (response.statusCode == 200) {
      print("signup successful");
      return UserInfo.fromSignUp(json.decode(response.body));
    } else {
      print("signup failed");
      throw Exception(response.body);
    }
  }

  Future<UserInfo> signInRequest({String email, String password, bool rmbMe}) async {

    final http.Response response = await http.post(
      '$baseUrl/signin',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,'password': password
      }),
    );

    print('${response.body}');
    print('${response.statusCode}');
    if (response.statusCode == 200) {
      print("signin successful");
      return UserInfo.fromSignUp(json.decode(response.body));
    } else {
      print("signup failed");
     throw Exception(response.body);
    }
  }

  Future<bool> checkTokenRequest({String token}) async {
    final http.Response response = await http.post(
      '$baseUrl/check/token',
      headers: <String, String>{
        'Authorization': 'Bearer $token'
      }
    );

    print('${response.body}');
    print('${response.statusCode}');
    if (response.statusCode == 200) {
      print("Token verification was done successfully");
      return json.decode(response.body)['valid'];
    } else {
      print("Token verification failed");
     throw Exception(response.body);
    }
  }

  // COURSES!

  Future<CourseInfo> createCourse({String token, String username}) async {
    final http.Response response = await http.post(
      '$baseUrl/$username/courses',
      headers: <String, String>{
        'Authorization': 'Bearer $token'
      }
    );

    print('${response.body}');
    print('${response.statusCode}');
    if (response.statusCode == 200) {
      print("Course creation was done successfully");
      return CourseInfo.fromCreate(json.decode(response.body));
    } else {
      print("Course creation failed");
      throw Exception(response.body);
    }
  }

  Future<List<CourseInfo>> getCourses({String token, String username}) async {
    final http.Response response = await http.get(
      '$baseUrl/$username/courses',
      headers: <String, String>{
        'Authorization': 'Bearer $token'
      }
    );

    print('${response.body}');
    print('${response.statusCode}');
    if (response.statusCode == 200) {
      print("Retrieving courses was done successfully");
      List<CourseInfo> courses = List<CourseInfo>();
      for (final course in json.decode(response.body)) {
        courses.add(CourseInfo.fromList(course));
      }
      return courses;
    } else {
      print("Courses retrieving failed");
      throw Exception(response.body);
    }
  }

  Future<CourseInfo> showCourse({String token, String username, String courseId}) async {
    final http.Response response = await http.get(
      '$baseUrl/$username/courses/$courseId',
      headers: <String, String>{
        'Authorization': 'Bearer $token'
      }
    );

    print('${response.body}');
    print('${response.statusCode}');
    if (response.statusCode == 200) {
      print("Course show was done successfully");
      return CourseInfo.fromView(json.decode(response.body));
    } else {
      print("Course show failed");
      throw Exception(response.body);
    }
  }

  // STUDENTS!

  Future<StudentInfo> createStudent({String token, String username, String courseId}) async {
    final http.Response response = await http.post(
      '$baseUrl/$username/students',
      headers: <String, String>{
        'Authorization': 'Bearer $token'
      }
    );

    print('${response.body}');
    print('${response.statusCode}');
    if (response.statusCode == 200) {
      print("Student creation was done successfully");
      return StudentInfo.fromCreate(json.decode(response.body));
    } else {
      print("Student creation failed");
      throw Exception(response.body);
    }
  }

  Future<List<StudentInfo>> getStudents({String token, String username}) async {
    final http.Response response = await http.get(
      '$baseUrl/$username/students',
      headers: <String, String>{
        'Authorization': 'Bearer $token'
      }
    );

    print('${response.body}');
    print('${response.statusCode}');
    if (response.statusCode == 200) {
      print("Retrieving courses was done successfully");
      List<StudentInfo> students = List<StudentInfo>();
      for (final student in json.decode(response.body)) {
        students.add(StudentInfo.fromList(student));
      }
      return students;
    } else {
      print("Courses retrieving failed");
      throw Exception(response.body);
    }
  }

  Future<StudentInfo> showStudent({String token, String username, String studentId}) async {
    final http.Response response = await http.get(
      '$baseUrl/$username/students/$studentId',
      headers: <String, String>{
        'Authorization': 'Bearer $token'
      }
    );

    print('${response.body}');
    print('${response.statusCode}');
    if (response.statusCode == 200) {
      print("Student show was done successfully");
      return StudentInfo.fromView(json.decode(response.body));
    } else {
      print("Student show failed");
      throw Exception(response.body);
    }
  }

  // TEACHERS!

  Future<List<TeacherInfo>> getTeachers({String token, String username}) async {
    final http.Response response = await http.get(
      '$baseUrl/$username/professors',
      headers: <String, String>{
        'Authorization': 'Bearer $token'
      }
    );

    print('${response.body}');
    print('${response.statusCode}');
    if (response.statusCode == 200) {
      print("Retrieving courses was done successfully");
      List<TeacherInfo> teachers = List<TeacherInfo>();
      for (final course in json.decode(response.body)) {
        teachers.add(TeacherInfo.fromList(course));
      }
      return teachers;
    } else {
      print("Courses retrieving failed");
      throw Exception(response.body);
    }
  }

  Future<TeacherInfo> showTeacher({String token, String username, String teacherId}) async {
    final http.Response response = await http.get(
      '$baseUrl/$username/professors/$teacherId',
      headers: <String, String>{
        'Authorization': 'Bearer $token'
      }
    );

    print('${response.body}');
    print('${response.statusCode}');
    if (response.statusCode == 200) {
      print("Teacher show was done successfully");
      return TeacherInfo.fromView(json.decode(response.body));
    } else {
      print("Teacher show failed");
      throw Exception(response.body);
    }
  }
}
