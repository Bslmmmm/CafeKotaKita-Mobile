import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignupController {
  final String apiUrl = 'http://127.0.0.1:8000/api/auth/register'; 

  Future<void> registerUser({
    required String nama,
    required String email,
    required String noTelp,
    required String alamat,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'nama': nama,
          'email': email,
          'no_telp': noTelp,
          'alamat': alamat,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'])),
        );
        Navigator.pushReplacementNamed(context, '/login'); // arahkan ke halaman login
      } else {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Registrasi gagal')),
        );
      }
    } catch (e) {
      debugPrint('Error during registration: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Terjadi kesalahan. Coba lagi.')),
      );
    }
  }
}
