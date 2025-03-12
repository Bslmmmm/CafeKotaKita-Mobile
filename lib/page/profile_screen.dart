import 'package:flutter/material.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  final String username = "arielrezka"; // Data dari backend
  final String email = "e41231126@student.poljje.ac.id"; // Data dari backend
  final String phone = "+6285784695683"; // Data dari backend
  final String profileImage = "assets/profile.jpg"; // Gambar profil

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFFB13841)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Profil Saya",
          style: TextStyle(
            color: Color(0xFFB13841),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFB13841),
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(profileImage),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          username,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          email,
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                        Text(
                          phone,
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              side: BorderSide(color: Color(0xFFB13841)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              "Edit Profil",
              style: TextStyle(color: Color(0xFFB13841)),
            ),
          ),
          Spacer(),
          BottomNavigationBar(
            backgroundColor: Color(0xFFB13841),
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
              BottomNavigationBarItem(icon: Icon(Icons.location_on), label: ""),
              BottomNavigationBarItem(
                icon: Text(
                  "kafe\nkata\nkita",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                label: "",
              ),
              BottomNavigationBarItem(icon: Icon(Icons.groups), label: ""),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
            ],
          ),
        ],
      ),
    );
  }
}
