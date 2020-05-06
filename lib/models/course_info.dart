class CourseInfo {
  final int id;
  final String name;
  final String dbId;
  final String createdAt;
  final String updatedAt;
  final int students;
  final String professor;

  CourseInfo({this.name, this.dbId, this.id, this.createdAt, this.updatedAt, this.students, this.professor});

  factory CourseInfo.fromCreate(Map<String, dynamic> json) {
    return CourseInfo(
      dbId: json['db_id'],
      name: json['name'],
      id: json['id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at']
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
}
