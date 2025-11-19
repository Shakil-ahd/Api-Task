class UserModel {
  final String? token;

  UserModel({this.token});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(token: json['Token'] ?? json['token']);
  }
}
