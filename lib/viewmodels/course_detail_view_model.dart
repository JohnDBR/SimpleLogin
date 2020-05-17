
import 'package:login_flutter/base/base_model.dart';
import 'package:login_flutter/models/course_info.dart';
import 'package:login_flutter/services/course_service.dart';
import '../locator.dart';

class CourseDetailViewModel extends BaseModel {
  CourseService _courseService = locator<CourseService>();
  CourseInfo get course => _courseService.course;

  Future showCourse({
    String username, 
    String token,
    String courseId,
    final Function(dynamic) resultFunction, 
    final Function(dynamic) errorFunction,
    final Function() timeoutFunction}) async {
    setState(ViewState.Busy);
    await _courseService.showCourse(username: username, token: token, courseId: courseId)
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
}