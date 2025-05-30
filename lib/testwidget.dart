import 'package:KafeKotaKita/Features/DetailCafe/widgets/detail_header.dart';
import 'package:flutter/material.dart';
import 'package:KafeKotaKita/Features/main_page.dart';
import 'Features/Homepage/views/test_homep.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Custom Navigation Bar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: DetailCafeHeader(),
    );
  }
}
