// ignore_for_file: prefer_const_constructors, prefer_if_null_operators

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Controllers/User/UserController.dart';
import 'package:job_app/Screens/Auth/forgot_password.dart';
import 'package:job_app/Screens/Auth/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final UserAuthenticationController _userAuthenticationController =
      Get.put(UserAuthenticationController());

  @override
  void initState() {
    super.initState();
    _userAuthenticationController.logError.clear();
    _passwordController.clear();
    _userAuthenticationController.logLoading.value = false;
  }

  bool _passVisible = false;

  void validateAndLogin() {
    _userAuthenticationController.clearLogErrorMsg();
    bool hasError = false;
    if (_emailController.text.trim().isEmpty) {
      hasError = true;
      _userAuthenticationController.logError["email1"] = "email is required";
    }

    if (_passwordController.text.isEmpty) {
      hasError = true;
      _userAuthenticationController.logError["password"] =
          "password is required";
    }

    if (!hasError) {
      _userAuthenticationController.login(
          email: _emailController.text.trim(),
          password: _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 90, left: 25, right: 25),
            child: Column(
              children: [
                Text("Welcome Back",
                    style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D0140))),
                SizedBox(height: 15),
                Text("Sign in to your account",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(color: Color(0xFF524B6B))),
                SizedBox(height: 50),
                Obx(() {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: _userAuthenticationController
                                      .logError["email1"] ==
                                  null
                              ? "Email"
                              : _userAuthenticationController
                                  .logError["email1"],
                          hintStyle: TextStyle(
                              color: _userAuthenticationController
                                          .logError["email1"] ==
                                      null
                                  ? Color(0xFF0D0140)
                                  : Colors.red,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontSize: _userAuthenticationController
                                          .logError["email1"] ==
                                      null
                                  ? 16
                                  : 12),
                          prefixIcon: Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                SizedBox(height: 15),
                Obx(() {
                  String? passwordError =
                      _userAuthenticationController.logError["password"];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_passVisible,
                        decoration: InputDecoration(
                          hintText: passwordError == null
                              ? "Password"
                              : passwordError,
                          hintStyle: TextStyle(
                              color: passwordError == null
                                  ? Color(0xFF0D0140)
                                  : Colors.red,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontSize: passwordError == null ? 16 : 12),
                          prefixIcon: Icon(Icons.lock_outline),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _passVisible = !_passVisible;
                              });
                            },
                            child: Icon(
                              _passVisible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: Color(0xFF60778C),
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                      if (_userAuthenticationController.logError["email"] !=
                          null)
                        Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 10.0, right: 8.0),
                            child: Text(
                              _userAuthenticationController.logError["email"]!,
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                        )
                    ],
                  );
                }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        splashFactory: NoSplash.splashFactory,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (content) => ForgotPassword()));
                        _passwordController.clear();
                      },
                      child: Text(
                        "Forgot password?",
                        style: GoogleFonts.poppins(color: Color(0xFFAAA6B9)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25),
                Obx(() {
                  return _userAuthenticationController.logLoading.value
                      ? const CircularProgressIndicator(
                          strokeWidth: 2,
                          strokeAlign: -5,
                        )
                      : GestureDetector(
                          onTap: validateAndLogin,
                          child: Container(
                            width: 266,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xFF130160),
                            ),
                            child: Center(
                              child: Text("LOGIN",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                          ),
                        );
                }),
                SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "You don't have an account yet?",
                      style: GoogleFonts.poppins(color: Color(0xFF524B6B)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterPage()));
                        _userAuthenticationController.clearLogErrorMsg();
                        _passwordController.clear();
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        splashFactory: NoSplash.splashFactory,
                      ),
                      child: Text("Sign up",
                          style: GoogleFonts.poppins(
                              decoration: TextDecoration.underline,
                              decorationColor: Color(0xFFFF9228),
                              color: Color(0xFFFF9228))),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
