// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Controllers/User/UserController.dart';
import 'package:job_app/Screens/Auth/login_page.dart';

class ResetPassword extends StatefulWidget {
  final String email;
  const ResetPassword({super.key, required this.email});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final UserAuthenticationController _userAuthenticationController =
      UserAuthenticationController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();
  bool _passVisible = false;
  bool _passConfVisible = false;
  void validatePassword() async {
    bool hasError = false;
    if (_newPasswordController.text.isEmpty ||
        _confirmNewPasswordController.text.isEmpty) {
      hasError = true;
      _userAuthenticationController.passwordResetError["password"] =
          "*required";
    }
    if (_confirmNewPasswordController.text != _newPasswordController.text) {
      _userAuthenticationController.passwordResetError["match_password"] =
          "Password doesn't match";
      hasError = true;
    }
    if (!hasError) {
      _userAuthenticationController.passwordResetLoading.value = true;
      await Future.delayed(Duration(seconds: 5));
      bool sucess = await _userAuthenticationController.resetpassword(
          email: widget.email, newPassword: _newPasswordController.text);
      _userAuthenticationController.passwordResetLoading.value = false;
      if (sucess) {
        Fluttertoast.showToast(
          msg: "Sucessfully updated",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 4,
          backgroundColor: Color(0xFF130160),
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Get.offAll(LoginPage());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 50, left: 25, right: 25),
          child: Column(
            children: [
              Obx(() {
                String? errorText = _userAuthenticationController
                    .passwordResetError["password"];
                String? errorTextApi =
                    _userAuthenticationController.passwordResetError["message"];
                return Column(
                  children: [
                    Text("Change password",
                        style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0D0140))),
                    SizedBox(height: 25),
                    Text(
                        "Set a password that you can easily remember. Make sure to use a combination of letters, numbers, and symbols for added security",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(color: Color(0xFF524B6B))),
                    SizedBox(height: 30),
                    Image.asset(
                      "assets/images/forgot_password.png",
                      width: 130,
                      height: 100,
                    ),
                    SizedBox(height: 40),
                    TextFormField(
                      controller: _newPasswordController,
                      obscureText: !_passVisible,
                      decoration: InputDecoration(
                          hintText: errorText ?? "New Password",
                          hintStyle: TextStyle(
                              color: errorText == null
                                  ? Color(0xFF0D0140)
                                  : Colors.red,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontSize: errorText == null ? 16 : 12),
                          contentPadding: EdgeInsets.all(16),
                          suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _passVisible = !_passVisible;
                                });
                              },
                              child: _passVisible
                                  ? Icon(
                                      Icons.visibility_outlined,
                                      color: Color(0xFF60778C),
                                    )
                                  : Icon(Icons.visibility_off_outlined,
                                      color: Color(0xFF60778C))),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18))),
                    ),
                    SizedBox(height: 10),
                    errorTextApi != null
                        ? Text(
                            errorTextApi,
                            style: GoogleFonts.poppins(color: Colors.red),
                          )
                        : Container(),
                  ],
                );
              }),
              SizedBox(height: 8),
              Obx(() {
                String? matchError = _userAuthenticationController
                    .passwordResetError["match_password"];
                String? errorText = _userAuthenticationController
                    .passwordResetError["password"];
                String? errorTextApi =
                    _userAuthenticationController.passwordResetError["message"];
                return Column(
                  children: [
                    TextFormField(
                      controller: _confirmNewPasswordController,
                      obscureText: !_passConfVisible,
                      decoration: InputDecoration(
                          hintText: errorText ?? "Confirm Password",
                          hintStyle: TextStyle(
                              color: errorText == null
                                  ? Color(0xFF0D0140)
                                  : Colors.red,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontSize: errorText == null ? 16 : 12),
                          contentPadding: EdgeInsets.all(16),
                          suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _passConfVisible = !_passConfVisible;
                                });
                              },
                              child: _passConfVisible
                                  ? Icon(
                                      Icons.visibility_outlined,
                                      color: Color(0xFF60778C),
                                    )
                                  : Icon(Icons.visibility_off_outlined,
                                      color: Color(0xFF60778C))),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18))),
                    ),
                    SizedBox(height: 10),
                    errorTextApi != null
                        ? Text(
                            errorTextApi,
                            style: GoogleFonts.poppins(color: Colors.red),
                          )
                        : Container(),
                    matchError != null
                        ? Text(
                            matchError,
                            style: GoogleFonts.poppins(color: Colors.red),
                          )
                        : Container(),
                  ],
                );
              }),
              SizedBox(height: 25),
              Obx(() {
                return GestureDetector(
                  onTap: () async {
                    validatePassword();
                  },
                  child: Container(
                    width: 266,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xFF130160)),
                    child:
                        _userAuthenticationController.passwordResetLoading.value
                            ? Center(
                                child: CircularProgressIndicator(
                                strokeWidth: 2,
                                strokeAlign: -5,
                                color: Colors.white,
                              ))
                            : Center(
                                child: Text("Confirm",
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ),
                  ),
                );
              }),
            ],
          ),
        ),
      )),
    );
  }
}
