// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Screens/Auth/login_page.dart';

class EmailSucess extends StatefulWidget {
  const EmailSucess({super.key});

  @override
  State<EmailSucess> createState() => _EmailSucessState();
}

class _EmailSucessState extends State<EmailSucess> {
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
                Text("Successfully",
                    style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D0140))),
                SizedBox(height: 35),
                Text(
                    "Your password has been updated, please change your password regularly to avoid this happening",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(color: Color(0xFF524B6B))),
                SizedBox(height: 60),
                Image.asset(
                  "assets/images/email_success.png",
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
                          Get.offAll(() => LoginPage());
                        },
                        child: Container(
                          width: 266,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xFF130160)),
                          child: Center(
                            child: Text("BACK TO LOGIN",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
