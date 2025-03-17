import 'package:flutter/material.dart';
import 'package:tugas_flutter/auth/onboarding_screen.dart'; // Pastikan nama proyek benar di pubspec.yaml

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JobFinder',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 240, 93, 93),
      ),
      home:
          const OnBoardingScreen(), // Gunakan const untuk widget stateless yang tidak berubah
    );
  }
}
