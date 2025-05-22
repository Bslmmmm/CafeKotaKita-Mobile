import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tugas_flutter/Constant/colors.dart';
import 'package:tugas_flutter/Constant/textstyle.dart';
import '../controller/otp_controller.dart';  // import controller ini

class OtpForm extends StatelessWidget {
  OtpForm({Key? key}) : super(key: key);

  final OtpController controller = Get.put(OtpController());

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
                onKey: (event) => controller.onKeyPressed(index, event),
                child: TextField(
                  controller: controller.controllers[index],
                  focusNode: controller.focusNodes[index],
                  onChanged: (value) => controller.onOtpChanged(index, value),
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
        Obx(() {
          return TextButton(
            onPressed: controller.seconds.value == 0
                ? () {
                    controller.startTimer();
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
              controller.seconds.value == 0
                  ? "Resend OTP"
                  : "Resend OTP in 00:${controller.seconds.value.toString().padLeft(2, '0')}",
              style: AppTextStyles.poppinsBody(
                color: controller.seconds.value == 0 ? white : clrfont2,
              ),
            ),
          );
        }),

        const SizedBox(height: 32),

        // Verify Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: controller.verifyOtp,
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
                  fontSize: 20),
            ),
          ),
        ),
      ],
    );
  }
}
