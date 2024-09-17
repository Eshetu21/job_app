// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Controllers/User/UserController.dart';
import 'package:job_app/Screens/Auth/reset_password_sucess.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

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
      bool sucess = await _userAuthenticationController.resetpassword(
          newPassword: _newPasswordController.text);
      _userAuthenticationController.passwordResetLoading.value = false;
      if (sucess) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ResetPasswordSucess()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        margin: EdgeInsets.only(top: 50, left: 25, right: 25),
        child: Column(
          children: [
            Obx(() {
              String? errorText =
                  _userAuthenticationController.passwordResetError["password"];
              String? errorTextApi =
                  _userAuthenticationController.passwordResetError["message"];
              return Column(
                children: [
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
              String? errorText =
                  _userAuthenticationController.passwordResetError["password"];
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
            GestureDetector(
              onTap: () async {
                validatePassword();
              },
              child: Container(
                width: 266,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xFFD6CDFE)),
                child: _userAuthenticationController.passwordResetLoading.value
                    ? Center(child: CircularProgressIndicator())
                    : Center(
                        child: Text("Confirm",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF130160))),
                      ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
