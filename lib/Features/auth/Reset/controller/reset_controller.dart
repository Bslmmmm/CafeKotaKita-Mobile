import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:KafeKotaKita/service/api_config.dart';
import 'package:KafeKotaKita/Constant/colors.dart';
import 'package:KafeKotaKita/Constant/textstyle.dart';

class ResetPasswordController extends GetxController {
  final String email;
  final String otp;

  ResetPasswordController({required this.email, required this.otp});

  final formKey = GlobalKey<FormState>();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final obscureNewPassword = true.obs;
  final obscureConfirmPassword = true.obs;
  final isLoading = false.obs;

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  Future<void> resetPassword() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;

      try {
        final response = await http.post(
          Uri.parse(ApiConfig.resetpasswordendpoint),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': email,
            'otp': otp,
            'password': newPasswordController.text,
            'password_confirmation': confirmPasswordController.text,
          }),
        );

        final responseData = jsonDecode(response.body);

        if (response.statusCode == 200) {
          Get.dialog(
            AlertDialog(
              backgroundColor: primaryc,
              title: Text("Berhasil", style: AppTextStyles.montserratH1(color: white)),
              content: Text("Password berhasil direset!", style: AppTextStyles.poppinsBody(color: clrfont2)),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back();
                    Get.offAllNamed('/login');
                  },
                  child: Text("OK", style: AppTextStyles.poppinsBody(color: white, weight: AppTextStyles.semiBold)),
                ),
              ],
            ),
            barrierDismissible: false,
          );
        } else {
          Get.snackbar("Error", responseData['message'] ?? 'Terjadi kesalahan',
              snackPosition: SnackPosition.BOTTOM, backgroundColor: clreror, colorText: white);
        }
      } catch (e) {
        Get.snackbar("Error", "Gagal terhubung ke server",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: clreror, colorText: white);
      } finally {
        isLoading.value = false;
      }
    }
  }
}
