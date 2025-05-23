import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tugas_flutter/Constant/colors.dart';
import 'package:tugas_flutter/Constant/textstyle.dart';
import 'package:tugas_flutter/routes/app_routes.dart';
import 'package:tugas_flutter/service/api_config.dart';
import 'package:flutter/services.dart';


class OtpController extends GetxController {
  // FocusNodes dan Controllers untuk 6 input OTP
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());
  final List<TextEditingController> controllers = List.generate(6, (index) => TextEditingController());

  var seconds = 60.obs;
  Timer? _timer;

  String? email;

  @override
  void onInit() {
    super.onInit();
    startTimer();

    // Ambil argument email dari Get.arguments
    if (Get.arguments != null) {
      if (Get.arguments is Map<String, dynamic>) {
        email = Get.arguments['email'] as String?;
      } else if (Get.arguments is String) {
        email = Get.arguments;
      }
    }
  }

  void startTimer() {
    seconds.value = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds.value == 0) {
        timer.cancel();
      } else {
        seconds.value--;
      }
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    for (var node in focusNodes) {
      node.dispose();
    }
    for (var controller in controllers) {
      controller.dispose();
    }
    super.onClose();
  }

  void onOtpChanged(int index, String value) {
    if (value.isNotEmpty && index < focusNodes.length - 1) {
      FocusScope.of(Get.context!).requestFocus(focusNodes[index + 1]);
    }
  }

  void onKeyPressed(int index, RawKeyEvent event) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace) {
      if (controllers[index].text.isEmpty && index > 0) {
        FocusScope.of(Get.context!).requestFocus(focusNodes[index - 1]);
        controllers[index - 1].clear();
      }
    }
  }

  Future<void> verifyOtp() async {
    String enteredOtp = controllers.map((e) => e.text).join();

    if (email == null) {
      Get.snackbar(
        "Error",
        "Email tidak tersedia",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: clreror,
        colorText: white,
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(ApiConfig.verifyOtpEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'otp': enteredOtp,
        }),
      );

      final result = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Get.dialog(
          AlertDialog(
            backgroundColor: primaryc,
            title: Text(
              "Berhasil",
              style: AppTextStyles.montserratH1(color: white),
            ),
            content: Text(
              "OTP berhasil diverifikasi!",
              style: AppTextStyles.poppinsBody(color: clrfont2),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  print(email);
                  print(enteredOtp);
                  Get.back();
                  Get.toNamed(
                    AppRoutes.resetpassword,
                    arguments: {
                      'email': email!,
                      'otp': enteredOtp,
                    },
                  );
                },
                child: Text(
                  "OK",
                  style: AppTextStyles.poppinsBody(
                    color: white,
                    weight: AppTextStyles.semiBold,
                  ),
                ),
              )
            ],
          ),
        );
      } else {
        Get.snackbar(
          "Error",
          result['message'] ?? 'OTP salah',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: clreror,
          colorText: white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal menghubungi server",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: clreror,
        colorText: white,
      );
    }
  }
}
