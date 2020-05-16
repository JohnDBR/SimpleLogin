import 'package:login_flutter/models/user_info.dart';
import '../locator.dart';
import 'api.dart';

class AuthService {
  Api _api = locator<Api>();
  // String _email;
  // String _password;
  // String _token;
  UserInfo user;
  bool tokenStatus = false;

  Future signInRequest({String email, String password}) async {
    // _email = email;
    // _password = password;
    try {
      user = await _api.signInRequest(email: email, password: password);
    } catch (err) {
      print('service signInRequest ${err.toString()}');
      return Future.error(err.toString());
    }
  }

  Future signUpRequest({String email, String password, String username, String name}) async {
    // _email = email;
    // _password = password;
    try {
      user = await _api.signUpRequest(email: email, password: password, username: username, name: name);
    } catch (err) {
      print('service signUpRequest ${err.toString()}');
      return Future.error(err.toString());
    }
  }

  Future checkTokenRequest({String token}) async {
    try {
      tokenStatus = await _api.checkTokenRequest(token: token);
    } catch (err) {
      print('service signUpRequest ${err.toString()}');
      return Future.error(err.toString());
    }
  }
} 