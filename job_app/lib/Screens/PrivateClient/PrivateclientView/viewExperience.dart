// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Controllers/JobSeeker/experience_controller.dart';
import 'package:job_app/Screens/JobSeeker/job_seeker_experience.dart';

class ViewExperience extends StatefulWidget {
  const ViewExperience({super.key});

  @override
  State<ViewExperience> createState() => _ViewExperienceState();
}

class _ViewExperienceState extends State<ViewExperience> {
  final ExperienceController _experienceController =
      Get.put(ExperienceController());
  @override
  void initState() {
    _experienceController.showexperience();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _experienceController.showexperience(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (_experienceController.experienceDetails.isEmpty) {
            return Column(
              children: [
                Row(
                  children: [
                    Text("Experience",
                        style: GoogleFonts.poppins(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                Center(
                    child: SizedBox(
                  height: 100,
                  child: Column(
                    children: [
                      Icon(Icons.settings,
                          color: Color(0xFFFF9228).withOpacity(0.5), size: 50),
                      Text(
                        "No experiecne",
                        style: GoogleFonts.poppins(color: Colors.grey),
                      )
                    ],
                  ),
                ))
              ],
            );
          } else {
            return ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var experience =
                      _experienceController.experienceDetails[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Experience",
                          style: GoogleFonts.poppins(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            experience["exp_position_title"] ?? "Not Provided",
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
                    ],
                  );
                },
                separatorBuilder: (_, index) {
                  return SizedBox(height: 5);
                },
                itemCount: _experienceController.experienceDetails.length);
          }
        });
  }

  void navigateToEditExperience(
      bool isediting, int? expId, Map<String, dynamic>? exp) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => JobSeekerExperience(
                  isediting: isediting,
                  experienceId: expId,
                  experience: exp,
                )));
  }
}
