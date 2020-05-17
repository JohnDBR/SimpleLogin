import 'package:login_flutter/base/base_model.dart';
import 'package:login_flutter/models/teacher_info.dart';
import 'package:login_flutter/services/teacher_service.dart';
import '../locator.dart';

class TeacherDetailViewModel extends BaseModel {
  final TeacherService _studentService = locator<TeacherService>();
  List<TeacherInfo> get teachers => _studentService.teachers;

  Future showTeacher({
    String username, 
    String token,
    String teacherId,
    final Function(dynamic) resultFunction, 
    final Function(dynamic) errorFunction,
    final Function() timeoutFunction}) async {
    setState(ViewState.Busy);
    await _studentService.showTeacher(username: username, token: token, teacherId: teacherId)
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
