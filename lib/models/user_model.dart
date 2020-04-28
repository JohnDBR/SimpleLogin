import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier {
  String email = '';
  String password = '';
  bool logged = false;

  UserModel({this.email, this.password});

  void storeUsername(String mail, String pass) {
    // Shared Preferences code...
    email = mail;
    password = pass;
    notifyListeners();
  }

  void checkLogin(String mail, String pass) {
    if (email == mail.trim() && password == pass) {
      logged = true;
    } else {
      logged = false;
    }
    notifyListeners();
  }

  void signUp(String mail, String pass) {
    // SignIn code...
    email = mail;
    password = pass;
    notifyListeners();
  }

  void clear() {
    email = '';
    password = '';
    notifyListeners();
  }

  void logout() {
    logged = false;
    notifyListeners();
  }
}