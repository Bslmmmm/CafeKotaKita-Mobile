class UserModel {
  final String id;
  final String username;
  final String email;
  final String? bio;
  final String? profileImageUrl;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.bio,
    this.profileImageUrl,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      bio: map['bio'],
      profileImageUrl: map['profileImageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
    };
  }
}
