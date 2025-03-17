import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import '../page/home_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final MultiSelectController<String> countryController = MultiSelectController();

  final List<DropdownItem<String>> countryItems = [
    DropdownItem(label: 'Nepal', value: 'Nepal'),
    DropdownItem(label: 'Australia', value: 'Australia'),
    DropdownItem(label: 'India', value: 'India'),
    DropdownItem(label: 'China', value: 'China'),
    DropdownItem(label: 'USA', value: 'USA'),
    DropdownItem(label: 'UK', value: 'UK'),
    DropdownItem(label: 'Germany', value: 'Germany'),
    DropdownItem(label: 'France', value: 'France'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 240, 93, 93),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  "CY",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "CIHUYY",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 240, 93, 93),
                ),
              ),
              Text(
                "Create your account",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 30),
              
              // Username
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Username",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              // Email
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Email",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              // Password
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Password",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              // Dropdown Negara
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Select Country",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              MultiDropdown<String>(
                items: countryItems,
                controller: countryController,
                fieldDecoration: FieldDecoration(
                  hintText: 'Select a country',
                  border: OutlineInputBorder(),
                ),
                onSelectionChange: (selectedItems) {
                  print("Selected country: \$selectedItems");
                },
              ),
              SizedBox(height: 30),

              // Tombol Register
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 240, 93, 93),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  "Register",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              SizedBox(height: 20),

              // Link ke Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Sudah punya akun? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Text(
                      "Login di sini",
                      style: TextStyle(
                        color: Color.fromARGB(255, 240, 93, 93),
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
