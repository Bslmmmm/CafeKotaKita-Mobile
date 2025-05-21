import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tugas_flutter/Constant/colors.dart';
import 'package:tugas_flutter/Constant/textstyle.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tugas_flutter/routes/app_routes.dart';
import 'package:tugas_flutter/service/api_config.dart';

class OtpForm extends StatefulWidget {
  const OtpForm({Key? key}) : super(key: key);

  @override
  State<OtpForm> createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());

  int _seconds = 60;
  Timer? _timer;
  String? email;

  @override
  void initState() {
    super.initState();
    startTimer();

    // Get email from arguments
    Future.microtask(() {
      if (Get.arguments != null) {
        if (Get.arguments is Map<String, dynamic>) {
          setState(() {
            email = Get.arguments['email'] as String?;
          });
        } else if (Get.arguments is String) {
          setState(() {
            email = Get.arguments;
          });
        }
      }
    });
  }

  void startTimer() {
    _seconds = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        timer.cancel();
      } else {
        setState(() {
          _seconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty && index < _focusNodes.length - 1) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    }
  }

  void _onKeyPressed(int index, RawKeyEvent event) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_controllers[index].text.isEmpty && index > 0) {
        FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
        _controllers[index - 1].clear();
      }
    }
  }

  Future<void> _verifyOtp() async {
    String enteredOtp = _controllers.map((e) => e.text).join();

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // OTP Fields
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (index) {
            return SizedBox(
              width: 40,
              child: RawKeyboardListener(
                focusNode: FocusNode(),
                onKey: (event) => _onKeyPressed(index, event),
                child: TextField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  onChanged: (value) => _onOtpChanged(index, value),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  style: AppTextStyles.interBody(
                    color: white,
                    fontSize: 15,
                    weight: AppTextStyles.bold,
                  ),
                  decoration: InputDecoration(
                    counterText: "",
                    filled: true,
                    fillColor: Colors.transparent,
                    contentPadding: EdgeInsets.symmetric(vertical: 16),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: clrfont2, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: white, width: 1),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        
        const SizedBox(height: 32),
        
        // Resend OTP Button
        TextButton(
          onPressed: _seconds == 0
              ? () {
                  startTimer();
                  Get.snackbar(
                    "Info",
                    "OTP dikirim ulang",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: primaryc,
                    colorText: white,
                  );
                }
              : null,
          child: Text(
            _seconds == 0
                ? "Resend OTP"
                : "Resend OTP in 00:${_seconds.toString().padLeft(2, '0')}",
            style: AppTextStyles.poppinsBody(
              color: _seconds == 0 ? white : clrfont2,
            ),
          ),
        ),
        
        const SizedBox(height: 32),
        
        // Verify Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _verifyOtp,
            style: ElevatedButton.styleFrom(
              backgroundColor: white,
              foregroundColor: black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              elevation: 0,
            ),
            child: Text(
              "Submit",
              style: AppTextStyles.poppinsBody(
                color: black,
                weight: AppTextStyles.semiBold,
                fontSize: 20
              ),
            ),
          ),
        ),
      ],
    );
  }
}