import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../components/already_have_an_account_acheck.dart';
import '../../../Constant/constants.dart';
import '../../../Features/auth/Login/view/login_screen.dart';
import '../../../Controllers/signup_controller.dart';

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

  final SignupController _signupController = SignupController();

  void _registerUser() {
    if (_formKey.currentState!.validate()) {
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Username Field
          TextFormField(
            controller: _usernameController,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            decoration: const InputDecoration(
              hintText: "Username",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Username wajib diisi';
              }
              return null;
            },
          ),
          const SizedBox(height: defaultPadding),

          // Email Field
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            decoration: const InputDecoration(
              hintText: "Your email",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.email),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email wajib diisi';
              }
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(value)) {
                return 'Format email tidak valid';
              }
              return null;
            },
          ),
          const SizedBox(height: defaultPadding),

          // No Telp Field
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(15),
            ],
            decoration: const InputDecoration(
              hintText: "Your phone number",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.phone),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'No telepon wajib diisi';
              }
              return null;
            },
          ),
          const SizedBox(height: defaultPadding),

          // Alamat Field
          TextFormField(
            controller: _addressController,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            decoration: const InputDecoration(
              hintText: "Your address",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.location_on),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Alamat wajib diisi';
              }
              return null;
            },
          ),
          const SizedBox(height: defaultPadding),

          // Password Field
          TextFormField(
            controller: _passwordController,
            textInputAction: TextInputAction.done,
            obscureText: true,
            cursorColor: kPrimaryColor,
            decoration: const InputDecoration(
              hintText: "Your password",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.lock),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password wajib diisi';
              }
              if (value.length < 8) {
                return 'Password minimal 8 karakter';
              }
              return null;
            },
          ),
          const SizedBox(height: defaultPadding / 2),

          // Submit Button
          ElevatedButton(
            onPressed: _registerUser,
            child: Text("Sign Up".toUpperCase()),
          ),
          const SizedBox(height: defaultPadding),

          // Already Have an Account
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
