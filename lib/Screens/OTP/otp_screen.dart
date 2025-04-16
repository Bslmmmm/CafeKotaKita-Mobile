import 'package:flutter/material.dart';
import '../../Constant/constants.dart';
import 'components/otp.dart';
import 'components/otp_screen_image.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: const [
            SizedBox(height: defaultPadding * 2),
            OtpScreenTopImage(),
            OtpForm(),
          ],
        ),
      ),
    );
  }
}
