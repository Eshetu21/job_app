// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Controllers/JobSeeker/experience_controller.dart';
import 'package:job_app/Screens/JobSeeker/job_seeker_experience.dart';

class FetchExperience extends StatefulWidget {
  const FetchExperience({super.key});

  @override
  State<FetchExperience> createState() => _FetchExperienceState();
}

class _FetchExperienceState extends State<FetchExperience> {
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
                    Text("Experience", style: GoogleFonts.poppins(fontSize: 18)),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        navigateToEditExperience(true, null, null);
                      },
                      child: Text("Add",
                          style: GoogleFonts.poppins(color: Color(0xFFFF9228))),
                    ),
                  ],
                ),
                Center(
                    child: Container(
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
                    children: [
                      Row(
                        children: [
                          Text("Experience",
                              style: GoogleFonts.poppins(fontSize: 18)),
                          Spacer(),
                          if (_experienceController.experienceDetails.length ==
                              1)
                            GestureDetector(
                              onTap: () {
                                navigateToEditExperience(true, null, null);
                              },
                              child: Text("Add",
                                  style: GoogleFonts.poppins(
                                      color: Color(0xFFFF9228))),
                            ),
                          SizedBox(width: 20),
                          GestureDetector(
                            onTap: () {
                              int experienceId = experience["id"];
                              navigateToEditExperience(
                                  true, experienceId, experience);
                            },
                            child: Text("Edit",
                                style: GoogleFonts.poppins(
                                    color: Color(0xFFFF9228))),
                          )
                        ],
                      ),
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
                            SizedBox(height: 4),
                            Text(
                              "Description: ${experience["exp_description"] ?? "Not Provided"}",
                              style: GoogleFonts.poppins(),
                            ),
                          ],
                        ),
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
