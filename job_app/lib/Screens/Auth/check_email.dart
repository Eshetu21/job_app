// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Screens/Auth/email_sucess.dart';
import 'package:job_app/Screens/Auth/login_page.dart';

class CheckEmail extends StatefulWidget {
  const CheckEmail({super.key});

  @override
  State<CheckEmail> createState() => _CheckEmailState();
}

class _CheckEmailState extends State<CheckEmail> {
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
                Text(
                    "We have sent the rest code to the email address eshetutesema2@gmail.com",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(color: Color(0xFF524B6B))),
                SizedBox(height: 60),
                Image.asset(
                  "assets/images/email_sent.png",
                  width: 130,
                  height: 100,
                ),
                SizedBox(height: 70),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.off(() => EmailSucess());
                        },
                        child: Container(
                          width: 266,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xFF130160)),
                          child: Center(
                            child: Text("OPEN YOUR EMAIL",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      GestureDetector(
                        onTap: () {
                          Get.offAll(LoginPage());
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
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "You have not received the code?",
                      style: GoogleFonts.poppins(color: Color(0xFF524B6B)),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
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
