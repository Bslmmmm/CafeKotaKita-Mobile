import 'package:KafeKotaKita/Features/Profile/view/pageProfile/about_profile.dart';
import 'package:KafeKotaKita/Features/Profile/view/pageProfile/contact_profile.dart';
import 'package:KafeKotaKita/Features/Profile/view/pageProfile/edit_profile.dart';
import 'package:KafeKotaKita/Features/SavedCafe/views/saved_cafe_screen.dart';
import 'package:get/get.dart';
import 'package:KafeKotaKita/Features/Onboarding/views/onboarding_page.dart';
import 'package:KafeKotaKita/Features/auth/Forgot/forgot_screen.dart';
import 'package:KafeKotaKita/Features/auth/Login/view/login_screen.dart';
import 'package:KafeKotaKita/Features/auth/Signup/signup_screen.dart';
import 'package:KafeKotaKita/Features/main_page.dart';
import 'package:KafeKotaKita/routes/app_routes.dart';
import 'package:KafeKotaKita/Features/auth/OTP/otp_screen.dart';
import 'package:KafeKotaKita/Features/auth/Reset/reset_screen.dart';

class AppPages {
  static final routes = [
    GetPage(name: AppRoutes.login, page: ()=>LoginScreen()),
    GetPage(name: AppRoutes.onboarding, page: ()=>OnboardingPage()),
    GetPage(name: AppRoutes.mainpage, page: ()=>MainPage()),
    GetPage(name: AppRoutes.verifyotp, page: () => OtpScreen()),
    GetPage(name: AppRoutes.resetpassword, page: () => ResetScreen()),
    GetPage(name: AppRoutes.signup, page: () => SignUpScreen()),
    GetPage(name: AppRoutes.forgotpass, page: () => ForgotScreen()),
    GetPage(name: AppRoutes.savedcafe, page: () => SavedCafeScreen()),
    GetPage(name: AppRoutes.aboutcafe, page: () => AboutCafePage()),
    GetPage(name: AppRoutes.contactus, page: () => ContactUsPage()),
    GetPage(name: AppRoutes.editprofile, page: () => EditProfilePage()),
  ];
}
