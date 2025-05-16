import 'package:flutter/material.dart';
import 'package:tugas_flutter/responsive.dart';
import '../../Constant/constants.dart';

// Komponen lokal
import 'components/reset_form.dart';
import 'components/reset_screen_image.dart';

class ResetScreen extends StatelessWidget {
  final String email;
  final String otp;

  const ResetScreen({
    Key? key,
    required this.email,
    required this.otp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(defaultPadding),
          child: Responsive(
            mobile: MobileResetScreen(email: email, otp: otp),
            desktop: Row(
              children: [
                const Expanded(child: ResetPasswordImage()),
                Expanded(
                  child: Center(
                    child: ResetPasswordForm(email: email, otp: otp),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MobileResetScreen extends StatelessWidget {
  final String email;
  final String otp;

  const MobileResetScreen({
    Key? key,
    required this.email,
    required this.otp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ResetPasswordImage(),
        const SizedBox(height: defaultPadding * 2),
        ResetPasswordForm(email: email, otp: otp),
      ],
    );
  }
}

