import 'package:login_flutter/base/base_model.dart';
import 'package:login_flutter/models/user_info.dart';
import 'package:login_flutter/services/auth_service.dart';
import '../locator.dart';

class StudentsViewModel extends BaseModel {
  final AuthService _authenticationService = locator<AuthService>();
  UserInfo get user => _authenticationService.user;

  Future signUp({
    String email,
    String password, 
    String username,
    String name, 
    final Function() resultFunction, 
    final Function(dynamic) errorFunction, 
    final Function() timeoutFunction}) async {
    setState(ViewState.Busy);
    await _authenticationService.signUpRequest(email: email, password: password, username: username, name: name)
      .then((val) {
        setState(ViewState.Idle);
        resultFunction();
      })
      .catchError((error) {
        setState(ViewState.Idle);
        errorFunction(error);
      })
      .timeout(Duration(seconds: 10), onTimeout: () {
        setState(ViewState.Idle);
        timeoutFunction();
      });
    notifyListeners();
  }
}
