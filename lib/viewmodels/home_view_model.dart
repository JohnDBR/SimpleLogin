
import 'package:login_flutter/base/base_model.dart';
import 'package:login_flutter/models/course_info.dart';
import 'package:login_flutter/services/course_service.dart';
import '../locator.dart';

class HomeViewModel extends BaseModel {
  CourseService _courseService = locator<CourseService>();

  List<CourseInfo> get courses => _courseService.courses;

  Future getCourses({
    String username,
    String token,
    final Function(dynamic) resultFunction,
    final Function(dynamic) errorFunction,
    final Function() timeoutFunction}) async {
    setState(ViewState.Busy);
    _courseService.getCourses(username: username, token: token)
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
  }

  Future addCourse({
    String username, 
    String token, 
    final Function(dynamic) resultFunction, 
    final Function(dynamic) errorFunction,
    final Function() timeoutFunction}) async {
    setState(ViewState.Busy);
    await _courseService.addCourse(username: username, token: token)
      .then((dynamic) {
        setState(ViewState.Idle);
        resultFunction(dynamic);
      })
      .catchError((error) {
        setState(ViewState.Idle);
        errorFunction(error); // return Future.error(error);
      })
      .timeout(Duration(seconds: 10), onTimeout: () {
        setState(ViewState.Idle);
        timeoutFunction();
      });
  }
}