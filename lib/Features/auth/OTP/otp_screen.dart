import 'package:flutter/material.dart';
import 'package:tugas_flutter/Constant/colors.dart';
import 'package:tugas_flutter/Constant/textstyle.dart';
import 'components/otp.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: primaryc,
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Center(
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
                      "Verification",
                      style: AppTextStyles.montserratH1(color: white).copyWith(
                        fontSize: 40, // Memperbesar ukuran font sesuai design
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Subtitle
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Kode OTP sudah berhasil terkirim\nke alamat email anda, Masukkan\nkode OTP di bawah ini.",
                      style: AppTextStyles.poppinsBody(color: clrfont2),
                    ),
                  ),
                  const SizedBox(height: 40),
                  OtpForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
