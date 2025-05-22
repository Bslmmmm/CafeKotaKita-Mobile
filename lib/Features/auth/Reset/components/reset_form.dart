import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_flutter/Constant/colors.dart';
import 'package:tugas_flutter/Constant/textstyle.dart';
import '../controller/reset_controller.dart';

class ResetPasswordForm extends StatefulWidget {
  final String email;
  final String otp;

  ResetPasswordForm({Key? key, required this.email, required this.otp}) : super(key: key) {
    Get.put(ResetPasswordController(email: email, otp: otp));
  }

  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void initState() {
    super.initState();
    final controller = Get.find<ResetPasswordController>();
    
    // Setup validation listeners
    controller.newPasswordController.addListener(() {
      setState(() {
        _passwordError = _validatePassword(controller.newPasswordController.text);
      });
    });

    controller.confirmPasswordController.addListener(() {
      setState(() {
        _confirmPasswordError = _validateConfirmPassword(
          controller.confirmPasswordController.text,
          controller.newPasswordController.text
        );
      });
    });
  }

  String? _validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password wajib diisi';
    }
    if (value.length < 8) {
      return 'Minimal memiliki 8 karakter';
    }
    return null;
  }

  String? _validateConfirmPassword(String value, String password) {
    
    if (value != password) {
      return 'Password tidak sama';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ResetPasswordController>();

    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text("Password", style: AppTextStyles.interBody(color: white, fontSize: 12)),
          ),
          const SizedBox(height: 8),

          // Password Field
          Obx(() => Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: clrfont2, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextFormField(
                  controller: controller.newPasswordController,
                  obscureText: controller.obscureNewPassword.value,
                  style: AppTextStyles.interBody(color: white),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    border: InputBorder.none,
                    fillColor: primaryc,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(8),
                      ), 
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.obscureNewPassword.value ? Icons.visibility_off : Icons.visibility,
                        color: white,
                      ),
                      onPressed: controller.obscureNewPassword.toggle,
                    ),
                  ),
                  
                ),
              )),

          // Password Error Message
          if (_passwordError != null)
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  _passwordError!,
                  style: AppTextStyles.interBody(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
            ),

          const SizedBox(height: 16),

          Align(
            alignment: Alignment.centerLeft,
            child: Text("Confirm Password", style: AppTextStyles.interBody(color: white, fontSize: 12)),
          ),
          const SizedBox(height: 8),

          // Confirm Password Field
          Obx(() => Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: clrfont2, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextFormField(
                  controller: controller.confirmPasswordController,
                  obscureText: controller.obscureConfirmPassword.value,
                  style: AppTextStyles.interBody(color: white),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    border: InputBorder.none,
                    fillColor: primaryc,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(8),
                      ), 
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.obscureConfirmPassword.value ? Icons.visibility_off : Icons.visibility,
                        color: white,
                      ),
                      onPressed: controller.obscureConfirmPassword.toggle,
                    ),
                  ),
                  
                ),
              )),

          // Confirm Password Error Message
          if (_confirmPasswordError != null)
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  _confirmPasswordError!,
                  style: AppTextStyles.interBody(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
            ),

          const SizedBox(height: 32),

          Obx(() => SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value ? null : () {
                    // Validate before submitting
                    setState(() {
                      _passwordError = _validatePassword(controller.newPasswordController.text);
                      _confirmPasswordError = _validateConfirmPassword(
                        controller.confirmPasswordController.text,
                        controller.newPasswordController.text
                      );
                    });

                    if (controller.formKey.currentState!.validate() &&
                        _passwordError == null &&
                        _confirmPasswordError == null) {
                      controller.resetPassword();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: white,
                    foregroundColor: black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : Text("Submit", style: AppTextStyles.poppinsBody(color: black, weight: AppTextStyles.semiBold, fontSize: 20)),
                ),
              )),
        ],
      ),
    );
  }
}