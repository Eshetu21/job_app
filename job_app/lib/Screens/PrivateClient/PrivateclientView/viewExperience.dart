// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Controllers/PrivateClient/privateclient_controller.dart';

class ViewExperience extends StatefulWidget {
  final Map applicant;
  const ViewExperience({super.key, required this.applicant});

  @override
  State<ViewExperience> createState() => _ViewExperienceState();
}

class _ViewExperienceState extends State<ViewExperience> {
  final PrivateclientController _privateclientController =
      Get.put(PrivateclientController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Experience",
            style:
                GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
        FutureBuilder(
            future: _privateclientController.getJobSeeker(
                jobSeekerId: widget.applicant["jobseeker"]["id"]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(
                  strokeWidth: 2,
                  strokeAlign: -5,
                ));
              }
              if (_privateclientController.getJobseekerExperience.isEmpty) {
                return Column(
                  children: [
                    Center(
                        child: SizedBox(
                      height: 100,
                      child: Column(
                        children: [
                          Icon(Icons.settings,
                              color: Color(0xFFFF9228).withOpacity(0.5),
                              size: 50),
                          Text(
                            "No experience",
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
                      var experience = _privateclientController
                          .getJobseekerExperience[index];
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
                                  experience["exp_position_title"] ??
                                      "Not Provided",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Company: ${experience["exp_company_name"] ?? "Not Provided"}",
                                  style: GoogleFonts.poppins(),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Job Type: ${experience["exp_job_type"] ?? "Not Provided"}",
                                  style: GoogleFonts.poppins(),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Start Date: ${experience["exp_start_date"] ?? "Not Provided"}",
                                  style: GoogleFonts.poppins(),
                                ),
                                SizedBox(height: 4),
                                Text(
                                    "End Date: ${experience["exp_end_date"] ?? "Not Provided"}",
                                    style: GoogleFonts.poppins()),
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
