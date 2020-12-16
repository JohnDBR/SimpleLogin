class TeacherInfo {
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

  TeacherInfo({this.id, this.personId, this.courseId, this.dbId, this.name, this.email, this.username, this.phone, this.city, this.country, this.birthday, this.createdAt, this.updatedAt});

  factory TeacherInfo.fromList(Map<String, dynamic> json) {
    return TeacherInfo(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      username: json['username']
    );
  }

  factory TeacherInfo.fromView(Map<String, dynamic> json) {
    return TeacherInfo(
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
