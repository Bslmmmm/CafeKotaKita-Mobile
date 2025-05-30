class UserModel {
  final String username;
  final String email;
  final String phoneNumber;
  final String profileImage;

  UserModel({
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.profileImage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Ambil foto profil dari key 'foto_profil_url' (sama dengan Laravel response)
    // Jika null atau kosong, fallback ke asset lokal
    String? fotoProfilUrl = json['foto_profil_url'];
    String profileImage = (fotoProfilUrl != null && fotoProfilUrl.isNotEmpty)
        ? fotoProfilUrl
        : 'assets/images/profile.jpg';

    return UserModel(
      username: json['nama'] ?? 'No Name',
      email: json['email'] ?? 'No Email',
      phoneNumber: json['no_telp'] ?? 'No Phone', // samakan key dengan API Laravel
      profileImage: profileImage,
    );
  }
}
