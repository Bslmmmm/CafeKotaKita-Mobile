import 'package:flutter/material.dart';
import '../../constants.dart';
import 'components/forgot_form.dart';
import 'components/forgot_screen_image.dart';
import '../../responsive.dart';

class ForgotScreen extends StatelessWidget {
  const ForgotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Responsive(
        mobile: MobileForgotScreen(),
        desktop: Row(
          children: const [
            Expanded(
              child: ForgotScreenTopImage(),
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(defaultPadding),
                  child: ForgotForm(),
                ),
              ),
            ),
          ],
        ),
        // Optional: tambahkan tablet jika ingin layout berbeda di tablet
        // tablet: ...
      ),
    );
  }
}

class MobileForgotScreen extends StatelessWidget {
  const MobileForgotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        children: const [
          ForgotScreenTopImage(),
          ForgotForm(),
        ],
      ),
    );
  }
}
