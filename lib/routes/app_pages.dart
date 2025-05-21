import 'package:get/get.dart';
import 'package:tugas_flutter/Features/Onboarding/views/onboarding_page.dart';
import 'package:tugas_flutter/Features/auth/Forgot/forgot_screen.dart';
import 'package:tugas_flutter/Features/auth/Login/view/login_screen.dart';
import 'package:tugas_flutter/Features/auth/Signup/signup_screen.dart';
import 'package:tugas_flutter/Features/main_page.dart';
import 'package:tugas_flutter/routes/app_routes.dart';
import 'package:tugas_flutter/Features/auth/OTP/otp_screen.dart';
import 'package:tugas_flutter/Features/auth/Reset/reset_screen.dart';

class AppPages {
  static final routes = [
    GetPage(name: AppRoutes.login, page: ()=>LoginScreen()),
    GetPage(name: AppRoutes.onboarding, page: ()=>OnboardingPage()),
    GetPage(name: AppRoutes.mainpage, page: ()=>MainPage()),
    GetPage(name: AppRoutes.verifyotp, page: () => OtpScreen()),
    GetPage(name: AppRoutes.resetpassword, page: () => ResetScreen()),
    GetPage(name: AppRoutes.signup, page: () => SignUpScreen()),
    GetPage(name: AppRoutes.forgotpass, page: () => ForgotScreen()),

    
  ];
}
