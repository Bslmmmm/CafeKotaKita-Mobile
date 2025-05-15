import 'package:flutter/material.dart';
import 'package:tugas_flutter/Features/Community/Screens/feed_screen.dart';
import 'Profile/ProfileScreen.dart';
import 'map.dart';
import 'package:tugas_flutter/Features/Community/Screens/feed_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static List<Widget> _pages = <Widget>[
    DashboardScreen(),
    MapScreen(
        latitude: 37.7749, longitude: -122.4194), // Sesuaikan dengan lokasi
    FeedScreen(),
    SetProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        height: 60, // Tinggi navbar diperbesar
        padding: EdgeInsets.only(
            top: 5, bottom: 5), // Padding untuk keseimbangan ikon
        decoration: BoxDecoration(
          color: Color(0xFFB13841), // Warna navbar
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                navItem(
                  Icons.home,
                  0,
                ),
                navItem(Icons.map, 1),
                SizedBox(width: 50), // Memberi ruang untuk logo di tengah
                navItem(Icons.people, 2),
                navItem(Icons.person, 3),
              ],
            ),
            Positioned(
              bottom: 10, // Supaya sejajar dengan ikon lainnya
              child: Image.asset(
                'assets/images/logo.png',
                width: 24, // Sesuaikan ukuran agar sama dengan ikon lainnya
                height: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget navItem(IconData icon, int index) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Icon(
        icon,
        size: 24, // Ukuran ikon tetap agar tidak berubah saat diklik
        color: _selectedIndex == index ? Colors.white : Colors.white70,
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner as Image
            Container(
              width: double.infinity,
              height: 200,
              child: Image.asset(
                'assets/images/banner.png',
                fit: BoxFit.cover,
              ),
            ),
            // Search Bar
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
            ),
            // 3 Buttons
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(3, (index) {
                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Icon(Icons.coffee, size: 40),
                      ),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: 20),
            // Cafe List
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Pilih kafe andalanmu',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey,
                  ),
                  title: Text('Cafe ${index + 1}'),
                  subtitle: Text('Alamat Cafe ${index + 1}'),
                  onTap: () {},
                );
              },
            ),
            SizedBox(height: 20),
            // Cafe Vibes
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Cari vibes kafe yang kamu mau',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(4, (index) {
                  return GestureDetector(
                    onTap: () {},
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey.shade300,
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
