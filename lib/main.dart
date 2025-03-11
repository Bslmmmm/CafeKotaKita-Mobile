import 'package:flutter/material.dart';
import 'auth/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JobFinder',
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 240, 93, 93),
      ),
      home: LoginScreen(), // Mulai dari halaman login dulu
    );
  }
}
