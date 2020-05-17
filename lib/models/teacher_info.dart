class TeacherInfo {
  final int id;
  final String name;
  final String dbId;
  final String createdAt;
  final String updatedAt;
  final int students;
  final String professor;

  TeacherInfo({this.name, this.dbId, this.id, this.createdAt, this.updatedAt, this.students, this.professor});

  factory TeacherInfo.fromCreate(Map<String, dynamic> json) {
    return TeacherInfo(
      name: json['name'],
      id: json['id'],
      students: json['students'],
      professor: json['professor']
    );
  }

  factory TeacherInfo.fromList(Map<String, dynamic> json) {
    return TeacherInfo(
      name: json['name'],
      id: json['id'],
      students: json['students'],
      professor: json['professor']
    );
  }
}
