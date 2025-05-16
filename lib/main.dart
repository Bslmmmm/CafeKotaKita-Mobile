import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tugas_flutter/Constant/colors.dart';
import 'package:tugas_flutter/routes/app_pages.dart';
import 'package:tugas_flutter/routes/app_routes.dart';
import 'firebase_options.dart';
import 'package:tugas_flutter/Screens/Forgot/forgot_screen.dart';
import 'package:tugas_flutter/Screens/OTP/otp_screen.dart';
import 'package:tugas_flutter/Screens/Reset/reset_screen.dart';
import 'package:tugas_flutter/Features/auth/Login/view/login_screen.dart';
import 'package:tugas_flutter/Features/Homepage/views/home_screen.dart';
import 'package:tugas_flutter/Constant/constants.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KafeKotaKita',
      initialRoute: AppRoutes.onboarding,
      getPages: AppPages.routes,
      theme: ThemeData(
        primaryColor: primaryc,
        scaffoldBackgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            foregroundColor: Colors.white,
            backgroundColor: clrbg,
            shape: const StadiumBorder(),
            maximumSize: const Size(double.infinity, 56),
            minimumSize: const Size(double.infinity, 56),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: clrbg,
          iconColor: white,
          prefixIconColor: white,
          contentPadding: EdgeInsets.symmetric(
              horizontal: defaultPadding, vertical: defaultPadding),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      routes: {
        '/forgot': (context) => const ForgotScreen(),
        '/otp': (context) => const OtpScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => HomeScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/reset') {
          final args = settings.arguments as Map<String, String>;
          return MaterialPageRoute(
            builder: (context) => ResetScreen(
              email: args['email']!,
              otp: args['otp']!,
            ),
          );
        }
        return null;
      },
    );
  }
}
