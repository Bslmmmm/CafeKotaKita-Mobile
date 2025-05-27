import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../service/service.dart';

class ProfileController extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String _error = '';
  final ApiService _apiService = ApiService();

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> getUserProfile() async {
    try {
      _isLoading = true;
      notifyListeners();
      
      // Simulasi data karena belum ada API yang terintegrasi
      // Nantinya akan memanggil API service untuk mendapatkan data user
      await Future.delayed(const Duration(seconds: 1));
      
      _user = UserModel(
        username: 'arielrezka',
        email: 'e41231126@student.polije.ac.id',
        phoneNumber: '+6285748695683',
        profileImage: 'assets/images/profile.jpg',
      );
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  void navigateToSavedCafes(BuildContext context) {
    // Implementasi navigasi ke halaman Saved Cafes
    debugPrint('Navigate to Saved Cafes');
  }

  void navigateToEditProfile(BuildContext context) {
    // Implementasi navigasi ke halaman Edit Profile
    debugPrint('Navigate to Edit Profile');
  }

  Future<void> deleteAccount(BuildContext context) async {
    // Implementasi delete account
    // Tampilkan dialog konfirmasi dulu
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Akun'),
        content: const Text('Apakah Anda yakin ingin menghapus akun?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (result == true) {
      // Panggil API untuk hapus akun
      debugPrint('Delete Account');
    }
  }

  void logout(BuildContext context) {
    // Implementasi logout
    // Tampilkan dialog konfirmasi dulu
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
              // Implementasi logout
              debugPrint('Logout');
            },
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  void navigateToAboutCafe(BuildContext context) {
    // Implementasi navigasi ke halaman About Cafe
    debugPrint('Navigate to About Cafe');
  }

  void navigateToContactUs(BuildContext context) {
    // Implementasi navigasi ke halaman Contact Us
    debugPrint('Navigate to Contact Us');
  }
}