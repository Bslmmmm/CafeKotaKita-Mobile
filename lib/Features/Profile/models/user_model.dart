class UserModel {
  final String username;
  final String email;
  final String phoneNumber;
  final String profileImage;

  UserModel({
    required this.username,
    required this.email,
    required this.phoneNumber,
    this.profileImage = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      profileImage: json['profile_image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'phone_number': phoneNumber,
      'profile_image': profileImage,
    };
  }
}