// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Screens/Auth/login_page.dart';


class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE5E5E5),
        body: SafeArea(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 15, right: 40, top: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "AddisJobs",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, fontSize: 24),
                  )
                ],
              ),
              SizedBox(height: 50),
              Image.asset("assets/images/get_started.png"),
              SizedBox(height: 50),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Find Your", style: GoogleFonts.poppins(fontSize: 40)),
                  Text("Dream Job",
                      style: GoogleFonts.poppins(
                          decoration: TextDecoration.underline,
                          decorationColor: Color(0xFFFCA34D),
                          fontSize: 40,
                          color: Color(0xFFFCA34D))),
                  Text("Here!", style: GoogleFonts.poppins(fontSize: 40)),
                  Text(
                      "Explore all the most exciting job roles based on your interest and study major.",
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: Color(0XFF524B6B))),
                  SizedBox(height: 60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        },
                        child: Image.asset(
                          "assets/icons/arrow.png",
                          width: 53,
                          height: 56,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
