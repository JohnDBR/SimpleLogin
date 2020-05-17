class StudentInfo {
  final int id;
  final String name;
  final String dbId;
  final String createdAt;
  final String updatedAt;
  final int students;
  final String professor;

  StudentInfo({this.name, this.dbId, this.id, this.createdAt, this.updatedAt, this.students, this.professor});

  factory StudentInfo.fromCreate(Map<String, dynamic> json) {
    return StudentInfo(
      name: json['name'],
      id: json['id'],
      students: json['students'],
      professor: json['professor']
    );
  }

  factory StudentInfo.fromList(Map<String, dynamic> json) {
    return StudentInfo(
      name: json['name'],
      id: json['id'],
      students: json['students'],
      professor: json['professor']
    );
  }
}
