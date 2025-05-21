import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tugas_flutter/Constant/colors.dart';
import 'package:tugas_flutter/routes/app_routes.dart';
import '../../../../Constant/textstyle.dart';
import '../../Login/view/login_screen.dart';
import '../controller/signup_controller.dart';
import 'package:get/get.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for each field
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Subjects for debounce
  final BehaviorSubject<String> _usernameSubject = BehaviorSubject();
  final BehaviorSubject<String> _emailSubject = BehaviorSubject();
  final BehaviorSubject<String> _phoneSubject = BehaviorSubject();
  final BehaviorSubject<String> _addressSubject = BehaviorSubject();
  final BehaviorSubject<String> _passwordSubject = BehaviorSubject();

  // State variables
  bool _obscurePassword = true;
  String? _emailError;
  String? _passwordError;
  String? _addressError;
  String? _usernameError;
  String? _phoneError;

  final SignupController _signupController = SignupController();

  @override
  void initState() {
    super.initState();
    
    // Setup debounce for each field
    _setupUsernameValidation();
    _setupEmailValidation();
    _setupPhoneValidation();
    _setupAddressValidation();
    _setupPasswordValidation();
  }

  void _setupUsernameValidation() {
    _usernameSubject.stream
        .debounceTime(const Duration(milliseconds: 500))
        .listen((username) {
      setState(() {
        _usernameError = _validateUsername(username);
      });
    });

    _usernameController.addListener(() {
      _usernameSubject.add(_usernameController.text);
    });
  }

  void _setupEmailValidation() {
    _emailSubject.stream
        .debounceTime(const Duration(milliseconds: 500))
        .listen((email) {
      setState(() {
        _emailError = _validateEmail(email);
      });
    });

    _emailController.addListener(() {
      _emailSubject.add(_emailController.text);
    });
  }

  void _setupPhoneValidation() {
    _phoneSubject.stream
        .debounceTime(const Duration(milliseconds: 500))
        .listen((phone) {
      setState(() {
        _phoneError = _validatePhone(phone);
      });
    });

    _phoneController.addListener(() {
      _phoneSubject.add(_phoneController.text);
    });
  }

  void _setupAddressValidation() {
    _addressSubject.stream
        .debounceTime(const Duration(milliseconds: 500))
        .listen((address) {
      setState(() {
        _addressError = _validateAddress(address);
      });
    });

    _addressController.addListener(() {
      _addressSubject.add(_addressController.text);
    });
  }

  void _setupPasswordValidation() {
    _passwordSubject.stream
        .debounceTime(const Duration(milliseconds: 500))
        .listen((password) {
      setState(() {
        _passwordError = _validatePassword(password);
      });
    });

    _passwordController.addListener(() {
      _passwordSubject.add(_passwordController.text);
    });
  }

  String? _validateUsername(String value) {
    if (value.isEmpty) {
      return 'Username wajib diisi';
    }
    return null;
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

  String? _validatePhone(String value) {
    if (value.isEmpty) {
      return 'Phone number wajib diisi';
    }
    return null;
  }

  String? _validateAddress(String value) {
    if (value.isEmpty) {
      return 'Address wajib diisi';
    }
    return null;
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

  void _registerUser() {
    // Clear any remaining errors
    setState(() {
      _usernameError = _validateUsername(_usernameController.text);
      _emailError = _validateEmail(_emailController.text);
      _phoneError = _validatePhone(_phoneController.text);
      _addressError = _validateAddress(_addressController.text);
      _passwordError = _validatePassword(_passwordController.text);
    });

    if (_formKey.currentState!.validate() &&
        _usernameError == null &&
        _emailError == null &&
        _phoneError == null &&
        _addressError == null &&
        _passwordError == null) {
      _signupController.registerUser(
        nama: _usernameController.text,
        email: _emailController.text,
        noTelp: _phoneController.text,
        alamat: _addressController.text,
        password: _passwordController.text,
        context: context,
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _usernameSubject.close();
    _emailSubject.close();
    _phoneSubject.close();
    _addressSubject.close();
    _passwordSubject.close();
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
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  
                  // Create Account Text - Left aligned with larger font size
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Create Account",
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
                      "Daftarkan akunmu dan eksplor berbagai cafe",
                      style: AppTextStyles.poppinsBody(color: clrfont2),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Username Field Label
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Username",
                      style: AppTextStyles.interBody(
                        color: white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Username Field
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: clrfont2, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextFormField(
                      controller: _usernameController,
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
                      ),
                      validator: (value) => _usernameError,
                    ),
                  ),

                  // Username Error Message
                  if (_usernameError != null)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          _usernameError!,
                          style: AppTextStyles.interBody(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  
                  const SizedBox(height: 16),
                  
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
                      ),
                      validator: (value) => _emailError,
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
                  
                  const SizedBox(height: 16),
                  
                  // Phone Field Label
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Phone number",
                      style: AppTextStyles.interBody(
                        color: white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Phone Field
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: clrfont2, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(14),
                      ],
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
                      validator: (value) => _phoneError,
                    ),
                  ),

                  if (_phoneError != null)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          _phoneError!,
                          style: AppTextStyles.interBody(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  
                  const SizedBox(height: 16),
                  
                  // Address Field Label
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Address",
                      style: AppTextStyles.interBody(
                        color: white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Address Field
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: clrfont2, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextFormField(
                      controller: _addressController,
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
                      ),
                      validator: (value) => _addressError,
                    ),
                  ),
                  
                  // Address Error Message
                  if (_addressError != null)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          _addressError!,
                          style: AppTextStyles.interBody(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 16),
                  
                  // Password Field Label
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
                  
                  // Password Field
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: clrfont2, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
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
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: white,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) => _passwordError,
                    ),
                  ),
                  
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
                  
                  const SizedBox(height: 32),
                  
                  // Sign Up Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _registerUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: white,
                        foregroundColor: black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        "Sign up",
                        style: AppTextStyles.poppinsBody(
                          color: black,
                          weight: AppTextStyles.semiBold,
                          fontSize: 20
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Already have an account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: AppTextStyles.interBody(
                          color: clrfont2,
                          fontSize: 12,
                          weight: AppTextStyles.regular,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.offAllNamed(AppRoutes.login);
                        },
                        child: Text(
                          "Login",
                          style: AppTextStyles.interBody(
                            color: white,
                            fontSize: 12,
                            weight: AppTextStyles.medium,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}