import 'package:flutter/material.dart';
import 'package:tugas_flutter/responsive.dart';
import '../../Constant/constants.dart';

// Komponen lokal
import 'components/reset_form.dart';
import 'components/reset_screen_image.dart';

class ResetScreen extends StatelessWidget {
  const ResetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(defaultPadding),
          child: Responsive(
            mobile: const MobileResetScreen(),
            desktop: Row(
              children: const [
                Expanded(
                  child: ResetPasswordImage(),
                ),
                Expanded(
                  child: Center(
                    child: ResetPasswordForm(),
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
  const MobileResetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        ResetPasswordImage(),
        SizedBox(height: defaultPadding * 2),
        ResetPasswordForm(),
      ],
    );
  }
}
