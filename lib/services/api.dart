import 'package:login_flutter/models/course_info.dart';
import 'package:login_flutter/models/user_info.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// HTTP methods!
class Api {
  static const String baseUrl = 'https://movil-api.herokuapp.com';

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

}
