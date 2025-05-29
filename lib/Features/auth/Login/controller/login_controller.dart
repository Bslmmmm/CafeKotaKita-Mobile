import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:KafeKotaKita/Constant/constants.dart';
import 'package:KafeKotaKita/routes/app_routes.dart';
import 'package:KafeKotaKita/service/api_config.dart';
import '../../../../Constant/colors.dart';
import '../../../../Constant/textstyle.dart';

class LoginController {
  final TextEditingController loginController; // bisa email atau nama
  final TextEditingController passwordController;

  LoginController({
    required this.loginController,
    required this.passwordController,
  });

  Future<void> login(BuildContext context) async {
  final String login = loginController.text.trim();
  final String password = passwordController.text.trim();

  if (login.isEmpty || password.isEmpty) {
    _showErrorDialog("Username/Email dan password tidak boleh kosong");
    return;
  }

  final url = Uri.parse(ApiConfig.loginendpoint);
  final isEmail = login.contains("@");
  
  // Perbaikan di sini - langsung buat struktur yang benar
  Map<String, dynamic> requestBody = {
    "password": password
  };
  
  if (isEmail) {
    requestBody["login"] = {"email": login};
  } else {
    requestBody["login"] = {"nama": login};
  }

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody), // langsung encode requestBody
    );
    
    final data = jsonDecode(response.body);
    await GetStorage().write(profileKey, jsonEncode(data['user']));
    // print("Response: "+data.toString());
    if (response.statusCode == 200) {
      _showSuccessDialog(
        "Login berhasil",
        "Selamat datang ${data['user']['nama']}",
        () {
          Get.offAllNamed(AppRoutes.mainpage);
        },
      );
    } else {
      final message = data['message']?.toLowerCase() ?? '';

      if (message.contains('user tidak ditemukan') ||
          message.contains('email')) {
        _showErrorDialog('Username/Email tidak terdaftar atau salah');
      } else if (message.contains('password')) {
        _showErrorDialog('Password salah');
      } else {
        _showErrorDialog('Login gagal: ${data['message']}');
      }
    }
  } catch (e) {
    _showErrorDialog('Terjadi kesalahan: $e');
  }
}
  void _showSuccessDialog(
      String title, String message, VoidCallback onOkPressed) {
    Get.dialog(
      AlertDialog(
        backgroundColor: primaryc,
        title: Text(
          title,
          style: AppTextStyles.montserratH1(color: white),
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
        backgroundColor: Colors.red[400],
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
