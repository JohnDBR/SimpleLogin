import 'package:flutter/material.dart';
import 'package:login_flutter/models/user_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel extends ChangeNotifier {
  UserInfo userInfo;
  bool logged = false;

  void clear() {
    userInfo = null;
    notifyListeners();
  }

  Future loadSession() async {
    List result = await retrieveLoginStatus();
    loadUser(result[1], result[2], result[3], result[0]);
  }

  void loadUser(name, token, username, lgged) {
    logged = lgged;
    userInfo = UserInfo.partialLoad(token, name, username);
    notifyListeners();
  }

  void rememberMe(String email, String password, bool rememberMe) {
    saveRememberMe(rememberMe);
    saveEmail(email);
    savePassword(password);
  }

  void login(UserInfo usrInfo) {
    userInfo = usrInfo;
    logged = true;
    saveLoginStatus(true);
    saveToken(usrInfo.token);
    saveName(userInfo.name);
    saveUsername(userInfo.username);
    notifyListeners();
  }

  void logout() {
    logged = false;
    saveLoginStatus(false);
    saveToken('null');
    saveName(userInfo.name);
    saveUsername(userInfo.username);
    notifyListeners();
  }

  // Error handler methods!
  void tokenTimeout(String error) {
    if (error == 'Token inválido.') {
      logout();
    }
  }

  // Shared Preferences methods!
  void saveLoginStatus(bool logged) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('Saving logged into the shared preferences!');
    await prefs.setBool('logged', logged);
  }

  void saveRememberMe(bool rememberMe) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('Saving rememberMe into the shared preferences!');
    await prefs.setBool('rememberMe', rememberMe);
  }

  void saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('Saving token into the shared preferences!');
    await prefs.setString('token', token);
  }

  void saveName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('Saving name into the shared preferences!');
    await prefs.setString('name', name);
  }

  void saveUsername(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('Saving username into the shared preferences!');
    await prefs.setString('username', username);
  }

  void saveEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('Saving email into the shared preferences!');
    await prefs.setString('email', email);
  }

  void savePassword(String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('Saving password into the shared preferences!');
    await prefs.setString('password', password);
  }

  Future<List> retrieveRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool rmbMe = (prefs.getBool('rememberMe') ?? false);
    if (rmbMe) {
      String email = (prefs.getString('email') ?? 'null');
      String password = (prefs.getString('password') ?? 'null');
      return [email, password, true];
    }
    return ['null', 'null', false];
  } 

  Future<List> retrieveLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool lggd = (prefs.getBool('logged') ?? false);
    if (lggd) {
      String name = (prefs.getString('name') ?? 'null');
      String token = (prefs.getString('token') ?? 'null');
      String username = (prefs.getString('username') ?? 'null');
      return [true, name, token, username];
    }
    return [false, 'null', 'null', 'null'];
  }  
}