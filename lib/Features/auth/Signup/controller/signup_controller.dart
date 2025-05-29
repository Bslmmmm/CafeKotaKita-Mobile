import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:KafeKotaKita/routes/app_routes.dart';
import 'package:KafeKotaKita/service/api_config.dart';
import '../../../../Constant/colors.dart';
import '../../../../Constant/textstyle.dart';

class SignupController extends GetxController {
  // Endpoint
  final String registerUrl = ApiConfig.registerendpoint;
  final String checkNamaUrl = ApiConfig.checkusernameendpoint;
  final String checkEmailUrl = ApiConfig.checkemailendpoint;

  // State untuk loading
  final RxBool isLoading = false.obs;
  final RxBool isCheckingNama = false.obs;
  final RxBool isCheckingEmail = false.obs;

  // Method untuk cek ketersediaan nama
  Future<Map<String, dynamic>> checkNamaAvailability(String nama) async {
    try {
      isCheckingNama.value = true;
      final response = await http.post(
        Uri.parse(checkNamaUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'nama': nama}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return {'available': false, 'message': 'Gagal memeriksa nama'};
    } catch (e) {
      debugPrint('Error checking nama: $e');
      return {'available': false, 'message': 'Error koneksi'};
    } finally {
      isCheckingNama.value = false;
    }
  }

  // Method untuk cek ketersediaan email
  Future<Map<String, dynamic>> checkEmailAvailability(String email) async {
    try {
      isCheckingEmail.value = true;
      final response = await http.post(
        Uri.parse(checkEmailUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return {'available': false, 'message': 'Gagal memeriksa email'};
    } catch (e) {
      debugPrint('Error checking email: $e');
      return {'available': false, 'message': 'Error koneksi'};
    } finally {
      isCheckingEmail.value = false;
    }
  }

  // Method utama untuk registrasi
  Future<void> registerUser({
    required String nama,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      isLoading.value = true;

      // Validasi real-time sebelum registrasi
      final namaCheck = await checkNamaAvailability(nama);
      final emailCheck = await checkEmailAvailability(email);

      if (!namaCheck['available'] || !emailCheck['available']) {
        String errorMessage = '';
        if (!namaCheck['available']) errorMessage = namaCheck['message'];
        if (!emailCheck['available']) {
          errorMessage += '${errorMessage.isNotEmpty ? '\n' : ''}${emailCheck['message']}';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
        return;
      }

      // Proses registrasi
      final response = await http.post(
        Uri.parse(registerUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nama': nama,
          'email': email,
          'password': password,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        _showSuccessDialog();
        await Future.delayed(const Duration(seconds: 2));
        Get.offAllNamed(AppRoutes.login);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? 'Registrasi gagal')),
        );
      }
    } catch (e) {
      debugPrint('Error during registration: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Terjadi kesalahan. Coba lagi.')),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _showSuccessDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: primaryc, 
        title: Text(
          "Berhasil",
          style: AppTextStyles.montserratH1(color: white),
        ),
        content: Text(
          "Registrasi berhasil!",
          style: AppTextStyles.poppinsBody(color: clrfont2),
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