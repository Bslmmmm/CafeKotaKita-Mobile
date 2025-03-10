// import 'package:flutter/material.dart';
// import 'home_screen.dart';
// import 'profile_screen.dart';
// import 'map.dart';
// import 'comunity.dart';

// class MainScreen extends StatefulWidget {
//   @override
//   _MainScreenState createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   int _selectedIndex = 0;

//   final List<Widget> _pages = [
//     HomeScreen(),
//     ProfileScreen(),
//     Map(),

//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: (index) {
//           setState(() {
//             _selectedIndex = index;
//           });
//         },
//         backgroundColor: Colors.white,
//         selectedItemColor: Color(0xFF405d4a), // Warna utama
//         unselectedItemColor: Colors.grey,
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: "Home",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: "Profile",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: "Map",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: "Community",
//           ),
//         ],
//       ),
//     );
//   }
// }
