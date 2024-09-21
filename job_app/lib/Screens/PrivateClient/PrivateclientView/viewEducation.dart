// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Controllers/PrivateClient/privateclient_controller.dart';

class ViewEducation extends StatefulWidget {
  final Map applicant;
  const ViewEducation({super.key, required this.applicant});

  @override
  State<ViewEducation> createState() => _ViewEducationState();
}

class _ViewEducationState extends State<ViewEducation> {
  final PrivateclientController _privateclientController =
      Get.put(PrivateclientController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Education",
            style:
                GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
        FutureBuilder(
            future: _privateclientController.getJobSeeker(
                jobSeekerId: widget.applicant["jobseeker"]["id"]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (_privateclientController.getJobseekerEducation.isEmpty) {
                return Column(
                  children: [
                    Center(
                        child: Container(
                      height: 100,
                      child: Column(
                        children: [
                          Icon(Icons.settings,
                              color: Color(0xFFFF9228).withOpacity(0.5),
                              size: 50),
                          Text(
                            "No education",
                            style: GoogleFonts.poppins(color: Colors.grey),
                          )
                        ],
                      ),
                    ))
                  ],
                );
              } else {
                return ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var education =
                          _privateclientController.getJobseekerEducation[index];
                      return Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.all(8.0),
                            margin: EdgeInsets.symmetric(vertical: 5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  education["school_name"] ?? "Not Provided",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Field: ${education["field"] ?? "Not Provided"}",
                                  style: GoogleFonts.poppins(),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Level: ${education["education_level"] ?? "Not Provided"}",
                                  style: GoogleFonts.poppins(),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Start Date: ${education["edu_start_date"] ?? "Not Provided"}",
                                  style: GoogleFonts.poppins(),
                                ),
                                SizedBox(height: 4),
                                Text(
                                    "End Date: ${education["edu_end_date"] ?? "Not Provided"}",
                                    style: GoogleFonts.poppins()),
                                SizedBox(height: 4),
                                Text(
                                  "Description: ${education["description"] ?? "Not Provided"}",
                                  style: GoogleFonts.poppins(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (_, index) {
                      return SizedBox(height: 3);
                    },
                    itemCount:
                        _privateclientController.getJobseekerEducation.length);
              }
            }),
      ],
    );
  }
}
