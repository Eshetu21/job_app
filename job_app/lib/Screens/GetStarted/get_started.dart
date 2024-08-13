// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Screens/Auth/login_page.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.only(left: 15, right: 40, top: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Addis",
                      style: GoogleFonts.poppins(
                          fontSize: 24, color: Color(0xFFFCA34D)),
                    ),
                    Text(
                      "Jobs",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold, fontSize: 24),
                    )
                  ],
                ),
                Spacer(),
                Image.asset("assets/images/get_started.png"),
                Spacer(),
                
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Find Your",
                        style: GoogleFonts.poppins(fontSize: 40)),
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
                        ),
                      
                      ],
                      
                    ),
               
                  ],
                ),
                  Spacer()
              ],
             
            ),
          ),
        ));
  }
}
