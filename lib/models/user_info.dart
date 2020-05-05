class UserInfo {
  final String token;
  final String username;
  final String name;
  final String email;

  UserInfo({this.token, this.username, this.name, this.email});

  factory UserInfo.fromSignUp(Map<String, dynamic> json) {
    return UserInfo(
      token: json['token'],
      username: json['username'],
      name: json['name'],
      email: json['email']
    );
  }

  factory UserInfo.fromSignIn(Map<String, dynamic> json, String email) {
    return UserInfo(
      token: json['token'],
      username: json['username'],
      name: json['name'],
      email: email
    );
  }

  factory UserInfo.partialLoad(String token, String name, String username) {
    return UserInfo(
      token: token,
      name: name,
      username: username
    );
  }
}
