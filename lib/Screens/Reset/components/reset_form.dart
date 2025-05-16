import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../Constant/constants.dart';

class ResetPasswordForm extends StatefulWidget {
  final String email;
  final String otp;

  const ResetPasswordForm({
    Key? key,
    required this.email,
    required this.otp,
  }) : super(key: key);

  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await http.post(
          Uri.parse('http://localhost:8000/api/auth/resetpassword'), // GANTI jika perlu
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': widget.email,
            'otp': widget.otp,
            'password': _newPasswordController.text,
            'password_confirmation': _confirmPasswordController.text,
          }),
        );

        final responseData = jsonDecode(response.body);

        if (response.statusCode == 200) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: const Text("Berhasil"),
              content: const Text("Password berhasil direset!"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (route) => false,
                    );
                  },
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("Gagal"),
              content: Text(responseData['message'] ?? 'Terjadi kesalahan'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                )
              ],
            ),
          );
        }
      } catch (e) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Error"),
            content: Text("Gagal terhubung ke server: $e"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              )
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _newPasswordController,
                textInputAction: TextInputAction.next,
                obscureText: true,
                cursorColor: kPrimaryColor,
                decoration: const InputDecoration(
                  hintText: "New Password",
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(defaultPadding),
                    child: Icon(Icons.lock_outline),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan password baru';
                  } else if (value.length < 6) {
                    return 'Password minimal 6 karakter';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                child: TextFormField(
                  controller: _confirmPasswordController,
                  textInputAction: TextInputAction.done,
                  obscureText: true,
                  cursorColor: kPrimaryColor,
                  decoration: const InputDecoration(
                    hintText: "Confirm Password",
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(defaultPadding),
                      child: Icon(Icons.lock),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Masukkan konfirmasi password';
                    } else if (value != _newPasswordController.text) {
                      return 'Password tidak sama';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: defaultPadding),
              ElevatedButton(
                onPressed: _resetPassword,
                child: Text("Reset Password".toUpperCase()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
