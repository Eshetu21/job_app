import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
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
                    Text("login",
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 266,
                      height: 50,
                      child: Center(
                          child: TextFormField(
                        /*  controller: _otpController, */
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
                    GestureDetector(
                      onTap: () async {},
                      child: Container(
                        width: 266,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color(0xFFD6CDFE)),
                        child: Center(
                          child: Text("Verify",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF130160))),
                        ),
                      ),
                    ),
                  ],
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
