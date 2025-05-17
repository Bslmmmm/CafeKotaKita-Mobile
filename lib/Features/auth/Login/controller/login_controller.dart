import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../../../../Constant/colors.dart';
import '../../../../Constant/textstyle.dart';

class LoginController {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  LoginController({
    required this.emailController,
    required this.passwordController,
  });

  Future<void> login(BuildContext context) async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog("Email dan password tidak boleh kosong");
      return;
    }

    final url = Uri.parse("http://127.0.0.1:8000/api/auth/login");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Login berhasil
        _showSuccessDialog(
          "Login berhasil", 
          "Selamat datang ${data['user']['nama']}",
          () {
            Get.offAllNamed('/home');
          }
        );
      } else {
        // Gagal login
        _showErrorDialog(data['message'] ?? 'Login gagal');
      }
    } catch (e) {
      _showErrorDialog('Terjadi kesalahan: $e');
    }
  }

  void _showSuccessDialog(String title, String message, VoidCallback onOkPressed) {
    Get.dialog(
      AlertDialog(
        backgroundColor: primaryc, // Make sure primaryc is defined
        title: Text(
          title,
          style: AppTextStyles.montserratH1(color: white), // Make sure these styles are available
        ),
        content: Text(
          message,
          style: AppTextStyles.poppinsBody(color: clrfont2),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              onOkPressed();
            },
            child: Text(
              "OK",
              style: AppTextStyles.poppinsBody(
                color: white,
                weight: AppTextStyles.semiBold,
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _showErrorDialog(String message) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.red[400], // Error color
        title: Text(
          "Error",
          style: AppTextStyles.montserratH1(color: white),
        ),
        content: Text(
          message,
          style: AppTextStyles.poppinsBody(color: white),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "OK",
              style: AppTextStyles.poppinsBody(
                color: white,
                weight: AppTextStyles.semiBold,
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}