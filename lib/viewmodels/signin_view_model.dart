import 'package:login_flutter/base/base_model.dart';
import 'package:login_flutter/models/user_info.dart';
import 'package:login_flutter/services/auth_service.dart';
import '../locator.dart';

class SignInViewModel extends BaseModel {
  final AuthService _authenticationService = locator<AuthService>();
  UserInfo get user => _authenticationService.user;
 
  Future signIn({
    String email,
    String password,
    final Function() resultFunction,
    final Function(dynamic) errorFunction,
    final Function() timeoutFunction}) async {
    setState(ViewState.Busy);
    await _authenticationService.signInRequest(email: email, password: password)
      .then((dynamic) {
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

  Future checkToken({
    String token,
    final Function(dynamic) resultFunction,
    final Function(dynamic) errorFunction,
    final Function() timeoutFunction}) async {
    setState(ViewState.Busy);
    await _authenticationService.checkTokenRequest(token: token)
      .then((dynamic) {
        setState(ViewState.Idle);
        resultFunction(dynamic);
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
