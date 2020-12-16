import 'package:get_it/get_it.dart';
import 'package:login_flutter/services/auth_service.dart';
import 'package:login_flutter/services/course_service.dart';
import 'package:login_flutter/services/student_service.dart';
import 'package:login_flutter/services/teacher_service.dart';
import 'package:login_flutter/viewmodels/course_detail_view_model.dart';
import 'package:login_flutter/viewmodels/home_view_model.dart';
import 'package:login_flutter/viewmodels/signin_view_model.dart';
import 'package:login_flutter/viewmodels/signup_view_model.dart';
import 'package:login_flutter/viewmodels/student_detail_view_model.dart';
import 'package:login_flutter/viewmodels/student_view_model.dart';
import 'package:login_flutter/viewmodels/teacher_detail_view_model.dart';
import 'package:login_flutter/viewmodels/teacher_view_model.dart';
import 'services/api.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => CourseService());
  locator.registerLazySingleton(() => StudentService());
  locator.registerLazySingleton(() => TeacherService());
  locator.registerLazySingleton(() => Api());

  locator.registerFactory(() => SignInViewModel());
  locator.registerFactory(() => SignUpViewModel());
  locator.registerFactory(() => HomeViewModel());
  locator.registerFactory(() => CourseDetailViewModel());
  locator.registerFactory(() => StudentViewModel());
  locator.registerFactory(() => StudentDetailViewModel());
  locator.registerFactory(() => TeacherViewModel());
  locator.registerFactory(() => TeacherDetailViewModel());

}
