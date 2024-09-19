// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Controllers/Profile/ProfileController.dart';
import 'package:job_app/Controllers/User/UserController.dart';
import 'package:job_app/Widgets/navigateprofile.dart';

class RegisterVerifyEmail extends StatefulWidget {
  final String email;
  const RegisterVerifyEmail({super.key, required this.email});

  @override
  State<RegisterVerifyEmail> createState() => _RegisterVerifyEmailState();
}

class _RegisterVerifyEmailState extends State<RegisterVerifyEmail> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final UserAuthenticationController _userAuthenticationController =
      Get.put(UserAuthenticationController());
  final ProfileController _profileController = Get.put(ProfileController());

  bool showOtpField = false;
  bool isCountdownActive = false;
  String verifyText = "Resend";
  Timer? _countdownTimer;
  int _start = 60;
  bool hasPressedVerifyBefore = false;

  void startCountdown() {
    setState(() {
      isCountdownActive = true;
    });
    const oneSec = Duration(seconds: 1);
    _countdownTimer = Timer.periodic(oneSec, (Timer timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
          _start = 60;
          verifyText = "Resend";
          isCountdownActive = false;
        });
      } else {
        setState(() {
          _start--;
          verifyText = "$_start s";
        });
      }
    });
  }

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
      print(otpcode);
      bool verifiedOTP =
          await _userAuthenticationController.checkPIN(pin: otpcode);
      _userAuthenticationController.otpVerifyLoading.value = false;
      if (verifiedOTP) {
        await _profileController.fetchProfiles();
        navigateBasedOnProfile();
      }
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _userAuthenticationController.verifyOTPError.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 90, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Email Verification",
                    style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D0140))),
                SizedBox(height: 25),
                Text("You need to verify your email in order to use the app",
                    style: GoogleFonts.poppins(color: Color(0xFF524B6B))),
                SizedBox(height: 20),
                Image.asset(
                  "assets/images/email_sent.png",
                  width: 130,
                  height: 100,
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 266,
                  height: 50,
                  child: Center(
                      child: TextFormField(
                    controller: _emailController,
                    readOnly: true,
                    decoration: InputDecoration(
                        hintText: widget.email,
                        contentPadding: EdgeInsets.all(20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        )),
                  )),
                ),
                SizedBox(height: 10),
                Obx(() {
                  String? errorText =
                      _userAuthenticationController.verifyOTPError["otp"];
                  return Column(children: [
                    showOtpField
                        ? Column(
                            children: [
                              _userAuthenticationController
                                          .otpVerifyLoading.value ==
                                      false
                                  ? Column(
                                      children: [
                                        SizedBox(
                                          width: 266,
                                          height: 50,
                                          child: TextFormField(
                                            controller: _otpController,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                hintText: "Enter OTP",
                                                contentPadding:
                                                    EdgeInsets.all(20),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                )),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        /* Text(
                                            "Check your email, we have sent a code"), */
                                      ],
                                    )
                                  : Container(),
                              SizedBox(height: 10),
                              errorText != null
                                  ? Text(
                                      errorText,
                                      style: GoogleFonts.poppins(
                                          color: Colors.red),
                                    )
                                  : Container(),
                              SizedBox(height: 10),
                            ],
                          )
                        : Container(),
                    GestureDetector(
                      onTap: () async {
                        if (!showOtpField) {
                          setState(() {
                            showOtpField = true;
                            hasPressedVerifyBefore = true;
                          });
                          bool testSendpin =
                              await _userAuthenticationController.sendpin();
                          if (testSendpin) {
                            Fluttertoast.showToast(
                              msg: "Check your email, we have sent a code",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.TOP,
                              timeInSecForIosWeb: 4,
                              backgroundColor: Color(0xFF130160),
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }
                          startCountdown();
                        } else {
                          if (_otpController.text.trim().isEmpty &&
                              hasPressedVerifyBefore) {
                            _userAuthenticationController.verifyEmailError
                                .clear();
                            validateOTP();
                          }
                          if (_otpController.text.trim().isNotEmpty &&
                              hasPressedVerifyBefore) {
                            _userAuthenticationController.verifyEmailError
                                .clear();
                            validateOTP();
                          }
                        }
                      },
                      child: Container(
                        width: 266,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color(0xFF130160)),
                        child: Center(
                          child: _userAuthenticationController
                                  .otpVerifyLoading.value
                              ? CircularProgressIndicator(color: Colors.white,)
                              : Text("Verify",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                        ),
                      ),
                    ),
                    showOtpField &&
                            _userAuthenticationController
                                    .otpVerifyLoading.value ==
                                false
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "You have not received the code?",
                                style: GoogleFonts.poppins(
                                    color: Color(0xFF524B6B)),
                              ),
                              TextButton(
                                  onPressed: () {
                                    if (!isCountdownActive) {
                                      startCountdown();
                                      _userAuthenticationController.sendpin();
                                    }
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    splashFactory: NoSplash.splashFactory,
                                  ),
                                  child: Text(verifyText,
                                      style: GoogleFonts.poppins(
                                          decoration: TextDecoration.underline,
                                          decorationColor: Color(0xFFFF9228),
                                          color: Color(0xFFFF9228)))),
                            ],
                          )
                        : SizedBox(height: 8),
                  ]);
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
