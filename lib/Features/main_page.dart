import 'package:flutter/material.dart';
import 'package:tugas_flutter/components/widget/custom_navbar.dart';
import 'package:tugas_flutter/Features/Homepage/views/test_homep.dart';
import 'SavedCafe/views/saved_cafe_screen.dart';


class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomepageView(),
    // SavedCafeScreen(),
    SavedCafeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomNavBar(
        initialSelectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
