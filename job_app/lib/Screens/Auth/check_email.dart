// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Controllers/User/UserController.dart';
import 'package:job_app/Screens/Auth/reset_password.dart';

class CheckEmail extends StatefulWidget {
  final String email;
  const CheckEmail({super.key, required this.email});

  @override
  State<CheckEmail> createState() => _CheckEmailState();
}

class _CheckEmailState extends State<CheckEmail> {
  final UserAuthenticationController _userAuthenticationController =
      UserAuthenticationController();
  final TextEditingController _otpController = TextEditingController();
  void validateOTP() async {
    bool hasError = false;
    if (_otpController.text.trim().isEmpty) {
      hasError = true;
      _userAuthenticationController.verifyOTPError["otp"] =
          "OTP can't be empty";
    }
    if (!hasError) {
      int otpcode;
      _userAuthenticationController.otpVerifyLoading.value = true;
      otpcode = int.parse(_otpController.text.trim());
      bool verifiedOTP = await _userAuthenticationController.verifyOTP(
          email: widget.email, pin: otpcode);
      _userAuthenticationController.otpVerifyLoading.value = false;
      if (verifiedOTP) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ResetPassword(email: widget.email)));
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Check You Email",
                    style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D0140))),
                SizedBox(height: 35),
                Column(
                  children: [
                    Text("We have sent the reset code to the email address",
                        style: GoogleFonts.poppins(color: Color(0xFF524B6B))),
                    Text(widget.email,
                        style: GoogleFonts.poppins(
                            color: Color(0xFF524B6B),
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 20),
                Image.asset(
                  "assets/images/email_sent.png",
                  width: 130,
                  height: 100,
                ),
                SizedBox(height: 20),
                Obx(() {
                  String? errorText =
                      _userAuthenticationController.verifyOTPError["otp"];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 266,
                        height: 50,
                        child: Center(
                            child: TextFormField(
                          controller: _otpController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: "Enter OTP",
                              contentPadding: EdgeInsets.all(20),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              )),
                        )),
                      ),
                      SizedBox(height: 10),
                      errorText != null
                          ? Text(
                              errorText,
                              style: GoogleFonts.poppins(color: Colors.red),
                            )
                          : Container(),
                      SizedBox(height: 25),
                      GestureDetector(
                        onTap: () async {
                          validateOTP();
                        },
                        child: Container(
                          width: 266,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xFFD6CDFE)),
                          child: _userAuthenticationController
                                  .otpVerifyLoading.value
                              ? Center(child: CircularProgressIndicator())
                              : Center(
                                  child: Text("Verify",
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF130160))),
                                ),
                        ),
                      ),
                    ],
                  );
                }),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "You have not received the code?",
                      style: GoogleFonts.poppins(color: Color(0xFF524B6B)),
                    ),
                    TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          splashFactory: NoSplash.splashFactory,
                        ),
                        child: Text("Resend",
                            style: GoogleFonts.poppins(
                                decoration: TextDecoration.underline,
                                decorationColor: Color(0xFFFF9228),
                                color: Color(0xFFFF9228)))),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
