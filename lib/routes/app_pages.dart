import 'package:get/get.dart';
import 'package:tugas_flutter/Features/Onboarding/views/onboarding_page.dart';
<<<<<<< HEAD
import 'package:tugas_flutter/Features/auth/Login/view/login_screen.dart';
import 'package:tugas_flutter/Features/main_page.dart';
=======
import 'package:tugas_flutter/Features/auth/Login/login_screen.dart';
>>>>>>> ff7743c9d5d1b66b20448ebb8464740c496468ed
import 'package:tugas_flutter/routes/app_routes.dart';
import 'package:tugas_flutter/Features/auth/OTP/otp_screen.dart';
import 'package:tugas_flutter/Features/auth/Reset/reset_screen.dart';

class AppPages {
  static final routes = [
    GetPage(name: AppRoutes.login, page: ()=>LoginScreen()),
    GetPage(name: AppRoutes.onboarding, page: ()=>OnboardingPage()),
<<<<<<< HEAD
    GetPage(name: AppRoutes.mainpage, page: ()=>MainPage())
=======
    GetPage(name: '/otp', page: () => const OtpScreen()),
    GetPage(name: '/reset', page: () => const ResetScreen()),
>>>>>>> ff7743c9d5d1b66b20448ebb8464740c496468ed
  ];
}
