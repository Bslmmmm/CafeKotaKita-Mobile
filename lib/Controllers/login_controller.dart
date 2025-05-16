import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginController {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  LoginController({
    required this.emailController,
    required this.passwordController,
  });

  Future<void> login(BuildContext context) async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showMessage(context, "Email dan password tidak boleh kosong");
      return;
    }

    final url = Uri.parse("http://127.0.0.1:8000/api/auth/login");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Login berhasil
        _showMessage(context, "Login berhasil, Selamat datang ${data['user']['nama']}");

        // Navigasi ke home
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Gagal login
        _showMessage(context, data['message'] ?? 'Login gagal');
      }
    } catch (e) {
      _showMessage(context, 'Terjadi kesalahan: $e');
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

