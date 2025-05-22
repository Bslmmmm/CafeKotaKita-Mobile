import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_flutter/Constant/colors.dart';
import 'package:tugas_flutter/Constant/textstyle.dart';
import 'components/reset_form.dart';

class ResetScreen extends StatelessWidget {
  const ResetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>  args = Get.arguments;
    final String email = args['email'] as String;
    final String otp = args['otp'] as String;

    return Scaffold(
      body: Container(
        color: primaryc,
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      // Title
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Reset Password",
                          style: AppTextStyles.montserratH1(color: white).copyWith(
                            fontSize: 40,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Subtitle
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Silahkan ganti password baru\nanda untuk mengganti password lama.",
                          style: AppTextStyles.poppinsBody(color: clrfont2),
                        ),
                      ),
                      const SizedBox(height: 40),
                      ResetPasswordForm(email: email, otp: otp),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}