import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_flutter/Constant/colors.dart';
import 'package:tugas_flutter/Constant/textstyle.dart';
import '../controller/forgot_controller.dart';

class ForgotForm extends StatefulWidget {
  ForgotForm({Key? key}) : super(key: key);

  @override
  State<ForgotForm> createState() => _ForgotFormState();
}

class _ForgotFormState extends State<ForgotForm> {
  final ForgotController controller = Get.put(ForgotController());
  String? _emailError;

  @override
  void initState() {
    super.initState();
    
    // Setup email validation listener
    controller.emailController.addListener(() {
      setState(() {
        _emailError = _validateEmail(controller.emailController.text);
      });
    });
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
      key: controller.formKey,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Email address",
              style: AppTextStyles.interBody(color: white, fontSize: 12),
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
              controller: controller.emailController,
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
          Obx(() => SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                          // Validate before submitting
                          setState(() {
                            _emailError = _validateEmail(controller.emailController.text);
                          });

                          if (controller.formKey.currentState!.validate() &&
                              _emailError == null) {
                            controller.sendOtp(context);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: white,
                    foregroundColor: black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : Text(
                          "Submit",
                          style: AppTextStyles.poppinsBody(
                            color: black,
                            weight: AppTextStyles.semiBold,
                            fontSize: 20,
                          ),
                        ),
                ),
              )),
        ],
      ),
    );
  }
}