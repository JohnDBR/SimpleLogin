import 'package:flutter/material.dart';
import 'package:login_flutter/models/course_info.dart';
import 'package:login_flutter/models/user_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UserModel extends ChangeNotifier {
  UserInfo userInfo;
  bool logged = false;

  void clear() {
    userInfo = null;
    notifyListeners();
  }

  void load(name, token, lgged) {
    logged = lgged;
    userInfo = UserInfo.partialLoad(token, name);
    notifyListeners();
  }

  void login(UserInfo usrInfo) {
    userInfo = usrInfo;
    logged = true;
    saveLoginStatus(true);
    saveToken(usrInfo.token);
    saveName(userInfo.name);
    notifyListeners();
  }

  void logout() {
    logged = false;
    saveLoginStatus(false);
    saveToken('null');
    saveName(userInfo.name);
    notifyListeners();
  }

  // HTTP methods!
  Future<UserInfo> signUpRequest({String email, String password, String username, String name}) async {

    final http.Response response = await http.post(
      'https://movil-api.herokuapp.com/signup',
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
      login(UserInfo.fromSignUp(json.decode(response.body)));
      return userInfo;
    } else {
      print("signup failed");
     throw Exception(response.body);
    }
  }

  Future<UserInfo> signInRequest({String email, String password}) async {

    final http.Response response = await http.post(
      'https://movil-api.herokuapp.com/signin',
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
      login(UserInfo.fromSignUp(json.decode(response.body)));
      return userInfo;
    } else {
      print("signup failed");
     throw Exception(response.body);
    }
  }

  Future<bool> checkTokenRequest({String token}) async {
    final http.Response response = await http.post(
      'https://movil-api.herokuapp.com/check/token',
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
      'https://movil-api.herokuapp.com/$username/courses',
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

  // Shared Preferences methods!
  void saveLoginStatus(bool logged) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('Saving logged into the shared preferences!');
    await prefs.setBool('logged', logged);
  }

  void saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('Saving logged into the shared preferences!');
    await prefs.setString('token', token);
  }

  void saveName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('Saving logged into the shared preferences!');
    await prefs.setString('name', name);
  }
}