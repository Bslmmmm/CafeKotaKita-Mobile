import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tugas_flutter/routes/app_routes.dart';
import 'package:tugas_flutter/service/api_config.dart';

class ForgotController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  var isLoading = false.obs;
  

  Future<void> sendOtp(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse(ApiConfig.forgotpasendpoint),
        headers: {'Content-Type': 'application/json',
        'Accept': 'application/json'},
        body: jsonEncode({'email': emailController.text}),
      );

      final result = jsonDecode(response.body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );
        Get.offNamed(AppRoutes.verifyotp, arguments: emailController.text);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Terjadi kesalahan')),
        );
      }
    } catch (e) {
      print("ERROR: $e"); // tambahkan ini
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak bisa menghubungi server')),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
