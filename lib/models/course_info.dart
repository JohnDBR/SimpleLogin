import 'package:login_flutter/models/student_info.dart';
import 'package:login_flutter/models/teacher_info.dart';

class CourseInfo {
  final int id;
  final String name;
  final String dbId;
  final String createdAt;
  final String updatedAt;
  final int students;
  final String professor;
  final TeacherInfo teacherInfo;
  final List<StudentInfo> studentsInfo;

  CourseInfo({this.name, this.dbId, this.id, this.createdAt, this.updatedAt, this.students, this.professor, this.teacherInfo, this.studentsInfo});

  factory CourseInfo.fromCreate(Map<String, dynamic> json) {
    return CourseInfo(
      name: json['name'],
      id: json['id'],
      students: json['students'],
      professor: json['professor']
    );
  }

  factory CourseInfo.fromList(Map<String, dynamic> json) {
    return CourseInfo(
      name: json['name'],
      id: json['id'],
      students: json['students'],
      professor: json['professor']
    );
  }

  factory CourseInfo.fromView(Map<String, dynamic> json) {
    List<StudentInfo> students = List<StudentInfo>();
      for (final student in json['students']) {
        students.add(StudentInfo.fromList(student));
      }
    return CourseInfo(
      name: json['name'],
      teacherInfo: TeacherInfo.fromList(json['professor']),
      studentsInfo: students
    );
  }
}
