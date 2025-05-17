import 'package:get/get.dart';
import 'package:tugas_flutter/Features/Onboarding/views/onboarding_page.dart';
import 'package:tugas_flutter/Features/auth/Login/login_screen.dart';
import 'package:tugas_flutter/routes/app_routes.dart';
import 'package:tugas_flutter/Features/auth/OTP/otp_screen.dart';
import 'package:tugas_flutter/Features/auth/Reset/reset_screen.dart';

class AppPages {
  static final routes = [
    GetPage(name: AppRoutes.login, page: ()=>LoginScreen()),
    GetPage(name: AppRoutes.onboarding, page: ()=>OnboardingPage()),
    GetPage(name: '/otp', page: () => const OtpScreen()),
    GetPage(name: '/reset', page: () => const ResetScreen()),
  ];
}
