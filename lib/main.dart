import 'package:flutter/material.dart';
import 'package:tugas_flutter/Screens/Welcome/welcome_screen.dart';
import 'package:tugas_flutter/Screens/Forgot/forgot_screen.dart'; // ← ini tambahkan
import 'package:tugas_flutter/Screens/OTP/otp_screen.dart'; // ← tambahkan ini
import 'package:tugas_flutter/Screens/Reset/reset_screen.dart'; // ← tambahkan ini
import 'package:tugas_flutter/Screens/Login/login_screen.dart';
import 'package:tugas_flutter/constants.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Auth',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            foregroundColor: Colors.white,
            backgroundColor: kPrimaryColor,
            shape: const StadiumBorder(),
            maximumSize: const Size(double.infinity, 56),
            minimumSize: const Size(double.infinity, 56),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: kPrimaryLightColor,
          iconColor: kPrimaryColor,
          prefixIconColor: kPrimaryColor,
          contentPadding: EdgeInsets.symmetric(
              horizontal: defaultPadding, vertical: defaultPadding),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: WelcomeScreen(),
      routes: {
        '/forgot': (context) => const ForgotScreen(), // ← ini penting!
        '/otp': (context) => const OtpScreen(), // ← ini penting
        '/reset': (context) => const ResetScreen(),
        '/login': (context) => const LoginScreen(), // bukan LoginForm ya
      },
    );
  }
}
