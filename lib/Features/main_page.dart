import 'package:KafeKotaKita/Constant/colors.dart';
import 'package:KafeKotaKita/Features/Search/view/search_view.dart';
import 'package:flutter/material.dart';
import 'package:KafeKotaKita/Features/Community/Screens/feed_screen.dart';
import 'package:KafeKotaKita/components/widget/custom_navbar.dart';
import 'package:KafeKotaKita/Features/Homepage/views/test_homep.dart';
import 'SavedCafe/views/saved_cafe_screen.dart';
import 'Profile/view/ProfileViews.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomepageView(),
    SearchView(),
    SavedCafeScreen(),
    FeedScreen(),
    ProfileScreen()
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
