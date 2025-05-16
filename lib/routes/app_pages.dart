import 'package:get/get.dart';
import 'package:tugas_flutter/Features/Onboarding/views/onboarding_page.dart';
import 'package:tugas_flutter/Features/auth/Login/view/login_screen.dart';
import 'package:tugas_flutter/routes/app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(name: AppRoutes.login, page: ()=>LoginScreen()),
    GetPage(name: AppRoutes.onboarding, page: ()=>OnboardingPage()),
  ];
}
