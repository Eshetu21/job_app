// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Controllers/User/UserController.dart';
import 'package:job_app/Screens/Auth/check_email.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final UserAuthenticationController _authenticationController =
      UserAuthenticationController();
  final TextEditingController _emailController = TextEditingController();
  void validateEmail() async {
    bool hasError = false;
    String email = _emailController.text.trim();
    if (email.isEmpty || !email.contains("@") || !email.contains(".")) {
      hasError = true;
      _authenticationController.verifyEmailError["email"] =
          "Please enter a valid email";
    } else {
      _authenticationController.verifyEmailError["email"] = null;
    }
    if (!hasError) {
      _authenticationController.otpLoading.value == true;
      bool emailExists =
          await _authenticationController.forgotPassword(email: email);
      _authenticationController.otpLoading.value == false;
      if (emailExists) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    CheckEmail(email: _emailController.text.trim())));
      } else {
        print("Failed to send OTP UI");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 60, left: 25, right: 25),
            child: Column(
              children: [
                Text("Forgot Password?",
                    style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D0140))),
                SizedBox(height: 35),
                Text(
                    "To reset your password, you need an email that can be authenticated",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(color: Color(0xFF524B6B))),
                SizedBox(height: 50),
                Image.asset(
                  "assets/images/forgot_password.png",
                  width: 130,
                  height: 100,
                ),
                SizedBox(height: 40),
                Obx(() {
                  String? errorText =
                      _authenticationController.verifyEmailError["email"];
                  return Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                            labelText: "Email",
                            prefixIcon: Icon(Icons.email_outlined),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18))),
                      ),
                      SizedBox(height: 10),
                      errorText != null
                          ? Text(
                              errorText,
                              style: GoogleFonts.poppins(color: Colors.red),
                            )
                          : Container()
                    ],
                  );
                }),
                SizedBox(
                  height: 25,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        print(_authenticationController
                            .verifyEmailError["email"]);
                        validateEmail();
                      },
                      child: Container(
                        width: 266,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color(0xFF130160)),
                        child: Obx(() {
                          return _authenticationController.otpLoading.value
                              ? Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.white))
                              : Center(
                                  child: Text("RESET PASSWORD",
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                );
                        }),
                      ),
                    ),
                    SizedBox(height: 30),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 266,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color(0xFFD6CDFE)),
                        child: Center(
                          child: Text("BACK TO LOGIN",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF130160))),
                        ),
                      ),
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
