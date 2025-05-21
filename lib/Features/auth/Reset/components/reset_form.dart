import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:tugas_flutter/Constant/colors.dart';
import 'package:tugas_flutter/Constant/textstyle.dart';
import 'dart:convert';

import 'package:tugas_flutter/service/api_config.dart';

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
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      try {
        final response = await http.post(
          Uri.parse(ApiConfig.resetpasswordendpoint),
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
          Get.dialog(
            AlertDialog(
              backgroundColor: primaryc,
              title: Text(
                "Berhasil",
                style: AppTextStyles.montserratH1(color: white),
              ),
              content: Text(
                "Password berhasil direset!",
                style: AppTextStyles.poppinsBody(color: clrfont2),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back();
                    Get.offAllNamed('/login');
                  },
                  child: Text(
                    "OK",
                    style: AppTextStyles.poppinsBody(
                      color: white,
                      weight: AppTextStyles.semiBold,
                    ),
                  ),
                ),
              ],
            ),
            barrierDismissible: false,
          );
        } else {
          Get.snackbar(
            "Error",
            responseData['message'] ?? 'Terjadi kesalahan',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: clreror,
            colorText: white,
          );
        }
      } catch (e) {
        Get.snackbar(
          "Error",
          "Gagal terhubung ke server",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: clreror,
          colorText: white,
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // New Password Field
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Password",
              style: AppTextStyles.interBody(
                color: white,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: clrfont2, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextFormField(
              controller: _newPasswordController,
              obscureText: _obscureNewPassword,
              textInputAction: TextInputAction.next,
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
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureNewPassword ? Icons.visibility_off : Icons.visibility,
                    color: white,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureNewPassword = !_obscureNewPassword;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Masukkan password baru';
                } else if (value.length < 8) {
                  return 'Minimal 8 karakter';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 16),
          
          // Confirm Password Field
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Confirm Password",
              style: AppTextStyles.interBody(
                color: white,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: clrfont2, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextFormField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
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
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                    color: white,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
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
          const SizedBox(height: 32),
          
          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _resetPassword,
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
}