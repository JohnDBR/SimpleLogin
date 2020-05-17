import 'package:login_flutter/base/base_model.dart';
import 'package:login_flutter/models/student_info.dart';
import 'package:login_flutter/services/student_service.dart';
import '../locator.dart';

class StudentViewModel extends BaseModel {
  final StudentService _studentService = locator<StudentService>();
  List<StudentInfo> get students => _studentService.students;

  Future getStudents({
    String username,
    String token,
    final Function(dynamic) resultFunction,
    final Function(dynamic) errorFunction,
    final Function() timeoutFunction}) async {
    setState(ViewState.Busy);
    _studentService.getStudents(username: username, token: token)
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

  Future addStudent({
    String username, 
    String token,
    String courseId,
    final Function(dynamic) resultFunction, 
    final Function(dynamic) errorFunction,
    final Function() timeoutFunction}) async {
    setState(ViewState.Busy);
    await _studentService.addStudent(username: username, token: token)
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
