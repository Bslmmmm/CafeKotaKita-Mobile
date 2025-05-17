import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../../../../Constant/colors.dart';
import '../../../../Constant/textstyle.dart';

class SignupController {
  final String apiUrl = 'http://127.0.0.1:8000/api/auth/register'; 

  Future<void> registerUser({
    required String nama,
    required String email,
    required String noTelp,
    required String alamat,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'nama': nama,
          'email': email,
          'no_telp': noTelp,
          'alamat': alamat,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        Get.dialog(
          AlertDialog(
            backgroundColor: primaryc, // Make sure primaryc is defined
            title: Text(
              "Berhasil",
              style: AppTextStyles.montserratH1(color: white), // Make sure these styles are available
            ),
            content: Text(
              "Registrasi berhasil!",
              style: AppTextStyles.poppinsBody(color: clrfont2),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
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
        
        // Navigate to login after 2 seconds (giving time to see the dialog)
        await Future.delayed(Duration(seconds: 2));
        Get.offAllNamed('/login');
      } else {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Registrasi gagal')),
        );
      }
    } catch (e) {
      debugPrint('Error during registration: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Terjadi kesalahan. Coba lagi.')),
      );
    }
  }
}