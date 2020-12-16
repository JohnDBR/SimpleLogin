import 'package:login_flutter/base/base_model.dart';
import 'package:login_flutter/models/teacher_info.dart';
import 'package:login_flutter/services/teacher_service.dart';
import '../locator.dart';

class TeacherViewModel extends BaseModel {
  final TeacherService _studentService = locator<TeacherService>();
  List<TeacherInfo> get teachers => _studentService.teachers;

  Future getTeachers({
    String username,
    String token,
    final Function(dynamic) resultFunction,
    final Function(dynamic) errorFunction,
    final Function() timeoutFunction}) async {
    setState(ViewState.Busy);
    _studentService.getTeachers(username: username, token: token)
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
