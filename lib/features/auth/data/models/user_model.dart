class UserModel {
  final String email;
  final String name;
  final String profileImage;

  UserModel({
    required this.email,
    required this.name,
    required this.profileImage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      name: json['name'],
      profileImage: json['profileImage'],
    );
  }
}
