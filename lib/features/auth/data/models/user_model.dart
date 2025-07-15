class UserModel {
  final String uid;
  final String email;
  final String name;
  final String profileImage;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.profileImage,
  });

  factory UserModel.fromFirestore(snapshot) {
    return UserModel(
      uid: snapshot['uid'],
      email: snapshot['email'],
      name: snapshot['name'],
      profileImage: snapshot['profileImage'],
    );
  }
}
