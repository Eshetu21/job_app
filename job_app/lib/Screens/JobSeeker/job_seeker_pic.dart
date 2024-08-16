// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Screens/JobSeeker/job_seeker_homepage.dart';

class JobSeekerPicture extends StatefulWidget {
  const JobSeekerPicture({super.key});

  @override
  State<JobSeekerPicture> createState() => _JobSeekerPictureState();
}

class _JobSeekerPictureState extends State<JobSeekerPicture> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        margin: EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(),
              child: Icon(
                Icons.account_circle_outlined,
                size: 300,
                color: Colors.grey,
              ),
            ),
            Text(
                "Upload a profile picture to create a strong first impression and make your profile stand out to potential employers.",
                style: GoogleFonts.poppins()),
            SizedBox(height: 180),
            GestureDetector(
              onTap: () {},
              child: Container(
                margin: EdgeInsets.only(bottom: 20),
                width: 266,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xFF130160).withOpacity(0.7),
                ),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.upload_outlined, color: Colors.white),
                  SizedBox(width: 5),
                  Text("Upload a profile picture",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                ]),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => JobSeekerHomepage()));
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 80),
                width: 266,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xFF130160).withOpacity(0.7),
                ),
                child: Center(
                  child: Text("NOT NOW",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
