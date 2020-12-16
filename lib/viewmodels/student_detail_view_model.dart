import 'package:login_flutter/base/base_model.dart';
import 'package:login_flutter/models/student_info.dart';
import 'package:login_flutter/services/student_service.dart';
import '../locator.dart';

class StudentDetailViewModel extends BaseModel {
  final StudentService _studentService = locator<StudentService>();
  StudentInfo get student => _studentService.student;

  Future showStudent({
    String username, 
    String token,
    String studentId,
    final Function(dynamic) resultFunction, 
    final Function(dynamic) errorFunction,
    final Function() timeoutFunction}) async {
    setState(ViewState.Busy);
    await _studentService.showStudent(username: username, token: token, studentId: studentId)
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
