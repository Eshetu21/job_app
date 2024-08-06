// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Controllers/JobSeeker/JobSeekerController.dart';

class JobSeekerHomepage extends StatefulWidget {
  const JobSeekerHomepage({super.key});

  @override
  State<JobSeekerHomepage> createState() => _JobSeekerHomepageState();
}

class _JobSeekerHomepageState extends State<JobSeekerHomepage> {
  final JobSeekerController _jobSeekerController =
      Get.put(JobSeekerController());

      @override
  void initState() {
    super.initState();
    _jobSeekerController.getJobSeeker();
    _jobSeekerController.fetchJobSeeker();
  }

  @override
  Widget build(BuildContext context) {
    print(_jobSeekerController.jobseeker);
    return Scaffold(
        backgroundColor: Color(0xFFE5E5E5),
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text("Welcome",
                        style: GoogleFonts.poppins(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    Spacer(),
                    Icon(Icons.settings_rounded),
                    SizedBox(width: 15),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.account_circle_outlined),
                    )
                  ],
                ),
                Obx(() {
                  if (_jobSeekerController.jobseeker.isEmpty) {
                    return CircularProgressIndicator();
                  } else {
                    return Text(
                      _jobSeekerController.jobseeker["user"]["firstname"],
                      style: GoogleFonts.poppins(fontSize: 20),
                    );
                  }
                }),
              ],
            ),
          ),
        ));
  }
}
