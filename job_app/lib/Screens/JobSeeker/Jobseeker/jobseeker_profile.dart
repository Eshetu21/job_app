// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Controllers/Profile/ProfileController.dart';

class JobseekerProfile extends StatefulWidget {
  const JobseekerProfile({super.key});

  @override
  State<JobseekerProfile> createState() => _JobseekerProfileState();
}

class _JobseekerProfileState extends State<JobseekerProfile> {
  final ProfileController _profileController = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFE5E5E5),
        body: SafeArea(
            child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(18),
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/profile_bg.png"),
                      fit: BoxFit.cover)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.account_circle_outlined,
                      size: 60, color: Color(0xFFFF9228)),
                  SizedBox(height: 12),
                  _profileController.isloading.value
                      ? Text("loading...")
                      : Text(
                          _profileController.profiles["jobseeker"]["user"]
                                  ["firstname"] +
                              " " +
                              _profileController.profiles["jobseeker"]["user"]
                                  ["lastname"],
                          style: GoogleFonts.poppins(color: Colors.white)),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          size: 20, color: Colors.white),
                      _profileController.profiles["jobseeker"]["user"]
                                  ["address"] !=
                              null
                          ? Text(
                              _profileController.profiles["jobseeker"]["user"]
                                  ["address"],
                              style: GoogleFonts.poppins(color: Colors.white),
                            )
                          : Text("Null",
                              style: GoogleFonts.poppins(color: Colors.white)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.email_outlined, size: 20, color: Colors.white),
                      _profileController.profiles["jobseeker"]["user"]
                                  ["email"] !=
                              null
                          ? Text(
                              _profileController.profiles["jobseeker"]["user"]
                                  ["email"],
                              style: GoogleFonts.poppins(color: Colors.white),
                            )
                          : Text("Null",
                              style: GoogleFonts.poppins(color: Colors.white)),
                    ],
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("Skills", style: GoogleFonts.poppins()),
                      Spacer(),
                      Text("Edit",style: GoogleFonts.poppins(color: Color(0xFFFF9228)))
                    ],
                  )
                ],
              ),
            ),
          ],
        )));
  }
}
