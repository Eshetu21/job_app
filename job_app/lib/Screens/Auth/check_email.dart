// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Screens/Auth/email_sucess.dart';

class CheckEmail extends StatefulWidget {
  final String email;
  CheckEmail({super.key, required this.email});

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
                          child: Center(
                              child: TextFormField(
                            decoration: InputDecoration(
                                labelText: "Enter OTP",
                                contentPadding: EdgeInsets.all(20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                )),
                          )),
                        ),
                      ),
                      SizedBox(height: 30),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 266,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xFFD6CDFE)),
                          child: Center(
                            child: Text("Submit",
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
