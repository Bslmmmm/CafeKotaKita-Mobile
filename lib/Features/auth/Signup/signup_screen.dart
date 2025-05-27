import 'package:flutter/material.dart';
import 'package:tugas_flutter/Constant/colors.dart';
import 'package:tugas_flutter/responsive.dart';
import 'components/signup_form.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryc,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Responsive(
            mobile: const MobileSignupScreen(),
            desktop: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 450),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const SignUpForm(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MobileSignupScreen extends StatelessWidget {
  const MobileSignupScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SignUpForm(),
        ),
      ],
    );
  }
}
