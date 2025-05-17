import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tugas_flutter/Constant/colors.dart';
import 'package:tugas_flutter/Constant/textstyle.dart';
import 'dart:convert';

class ForgotForm extends StatefulWidget {
  const ForgotForm({Key? key}) : super(key: key);

  @override
  State<ForgotForm> createState() => _ForgotFormState();
}

class _ForgotFormState extends State<ForgotForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  String? _emailError;

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8000/api/auth/forgotpassword'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': _emailController.text}),
      );

      final result = jsonDecode(response.body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );
        // Navigasi ke halaman OTP dengan email
        Navigator.pushNamed(context, '/otp', arguments: _emailController.text);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Terjadi kesalahan')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak bisa menghubungi server')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String? _validateEmail(String value) {
    if (value.isEmpty) {
      return 'Email wajib diisi';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [          
          // Email Field Label
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Email address",
              style: AppTextStyles.interBody(
                color: white,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 8),
          
          // Email Field
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: clrfont2, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              style: AppTextStyles.interBody(color: white),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                border: InputBorder.none,
                fillColor: primaryc,
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                final error = _validateEmail(value ?? '');
                setState(() => _emailError = error);
                return error;
              },
            ),
          ),
          
          // Email Error Message
          if (_emailError != null)
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  _emailError!,
                  style: AppTextStyles.interBody(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          
          const SizedBox(height: 32),
          
          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _sendOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: white,
                foregroundColor: black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Text(
                      "Submit",
                      style: AppTextStyles.poppinsBody(
                        color: black,
                        weight: AppTextStyles.semiBold,
                        fontSize: 20
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}