import 'package:flutter/material.dart';
import 'package:tugas_flutter/Constant/colors.dart';
import 'package:tugas_flutter/routes/app_routes.dart';
import '../controller/login_controller.dart';
import '../../../../Constant/textstyle.dart';
import '../../Signup/signup_screen.dart';
import 'package:get/get.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;

  late LoginController _loginController;

  @override
  void initState() {
    super.initState();
    _loginController = LoginController(
      emailController: _emailController,
      passwordController: _passwordController,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryc,
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo or empty space at top
                const SizedBox(height: 40),
                
                // Login Text - Left aligned with larger font size
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Log in",
                    style: AppTextStyles.montserratH1(color: white).copyWith(
                      fontSize: 40, 
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                
                // Subtitle - Left aligned
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Temukan kafe terbaik untukmu",
                    style: AppTextStyles.poppinsBody(color: clrfont2),
                  ),
                ),
                
                const SizedBox(height: 50),
                
                // Email Field Label - Left aligned, smaller size
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
                
                // Email Field - Black background with white border
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.transparent, // Transparent background
                    border: Border.all(color: clrfont2, width: 1), // White border
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: AppTextStyles.interBody(color: white),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      border: InputBorder.none,
                      fillColor: primaryc, // Using primaryc as fill color
                      filled: true, // Enable filling
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Password Field Label - Left aligned, smaller size
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
                
                // Password Field - Black background with white border
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.transparent, // Transparent background
                    border: Border.all(color: clrfont2, width: 1), // White border
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    style: AppTextStyles.interBody(color: white),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      border: InputBorder.none,
                      fillColor: primaryc, // Using primaryc as fill color
                      filled: true, // Enable filling
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
                          _obscureText ? Icons.visibility_off : Icons.visibility,
                          color: white, // Changed icon color to white to match border
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                
                // Forgot Password - Right aligned, smaller text
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.forgotpass);
                    },
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      "Forgot password?",
                      style: AppTextStyles.interBody(
                        color: clrfont2, 
                        fontSize: 12,
                        weight: AppTextStyles.regular,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Login Button - Rounded rectangle with white background
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      _loginController.login(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: white,
                      foregroundColor: black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      "Log in",
                      style: AppTextStyles.poppinsBody(
                        color: black,
                        weight: AppTextStyles.semiBold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                
                // Create Account - Right aligned, smaller text
                Align(
                  alignment: Alignment.centerRight, // Posisi ke kanan
                  child: TextButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.signup);
                    },
                    child: Text(
                      "Create account?",
                      style: AppTextStyles.interBody(
                        color: clrfont2,
                        fontSize: 12,
                        weight: AppTextStyles.regular,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}