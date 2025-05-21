import 'dart:async';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tugas_flutter/routes/app_routes.dart';
import 'package:tugas_flutter/service/api_config.dart';

class OtpController extends GetxController {

  final String? email = Get.arguments is String 
      ? Get.arguments 
      : Get.arguments?['email'];


  RxInt secondsRemaining = 60.obs;
  Timer? _timer;


  void startTimer() {
    secondsRemaining.value = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        timer.cancel();
      }
    });
  }

  // Kirim OTP ke API
  Future<void> verifyOtp(String otp) async {
    if (email == null) {
      Get.snackbar("Error", "Email tidak valid");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(ApiConfig.verifyOtpEndpoint),
        body: {'email': email, 'otp': otp},
      );

      if (response.statusCode == 200) {
        Get.offNamed(AppRoutes.resetpassword, arguments: email);
      } else {
        Get.snackbar("Error", "Kode OTP salah");
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal terhubung ke server");
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}