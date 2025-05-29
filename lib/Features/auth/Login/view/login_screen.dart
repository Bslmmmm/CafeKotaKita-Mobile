import 'package:flutter/material.dart';
import 'package:KafeKotaKita/Constant/colors.dart';
import 'package:KafeKotaKita/responsive.dart';
import '../components/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryc,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Responsive(
            mobile: const MobileLoginScreen(),
            desktop: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 450),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const LoginForm(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MobileLoginScreen extends StatelessWidget {
  const MobileLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: LoginForm(),
        ),
      ],
    );
  }
}
