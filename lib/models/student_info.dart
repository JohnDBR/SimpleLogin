class StudentInfo {
  final int id;
  final int personId;
  final int courseId;
  final String dbId;
  final String name;
  final String email;
  final String username;
  final String phone;
  final String city;
  final String country;
  final String birthday;
  final String createdAt;
  final String updatedAt;

  StudentInfo({this.id, this.personId, this.courseId, this.dbId, this.name, this.email, this.username, this.phone, this.city, this.country, this.birthday, this.createdAt, this.updatedAt});

  factory StudentInfo.fromCreate(Map<String, dynamic> json) {
    return StudentInfo(
      dbId: json['dbId'],
      id: json['id'],
      personId: json['person_id'],
      courseId: json['course_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at']
    );
  }

  factory StudentInfo.fromList(Map<String, dynamic> json) {
    return StudentInfo(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      username: json['username']
    );
  }

  factory StudentInfo.fromView(Map<String, dynamic> json) {
    return StudentInfo(
      courseId: json['course_id'],
      name: json['name'],
      username: json['username'],
      phone: json['phone'],
      email: json['email'],
      city: json['city'],
      country: json['country'],
      birthday: json['birthday']
    );
  }
}
