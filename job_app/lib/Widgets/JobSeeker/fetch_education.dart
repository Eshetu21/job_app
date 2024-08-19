// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Controllers/JobSeeker/education_controller.dart';
import 'package:job_app/Screens/JobSeeker/job_seeker_education.dart';

class FetchEducation extends StatefulWidget {
  const FetchEducation({super.key});

  @override
  State<FetchEducation> createState() => _FetchEducationState();
}

class _FetchEducationState extends State<FetchEducation> {
  final EducationController _educationController =
      Get.put(EducationController());
  @override
  void initState() {
    super.initState();
    _educationController.showeducation();
  }

  @override
  Widget build(BuildContext context) {
    print(_educationController.educationDetails);
    return FutureBuilder(
        future: _educationController.showeducation(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (_educationController.educationDetails.isEmpty) {
            return Column(
              children: [
                Row(
                  children: [
                    Text("Education", style: GoogleFonts.poppins(fontSize: 18)),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        navigateToEditEducation(true, null, null);
                      },
                      child: Text("Add",
                          style: GoogleFonts.poppins(color: Color(0xFFFF9228))),
                    ),
                  ],
                ),
                Center(child: Container(
                  height: 100,
                  child: Column(children: [
                    Icon(Icons.settings,color: Color(0xFFFF9228).withOpacity(0.5),size: 50),
                    Text("No education",style: GoogleFonts.poppins(color: Colors.grey),)
                  ],),
                ))
              ],
            );
          } else {
            return ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var education = _educationController.educationDetails[index];
                  return Column(
                    children: [
                      Row(
                        children: [
                          Text("Education",
                              style: GoogleFonts.poppins(fontSize: 18)),
                          Spacer(),
                          if (_educationController.educationDetails.length == 1)
                            GestureDetector(
                              onTap: () {
                                navigateToEditEducation(true, null, null);
                              },
                              child: Text("Add",
                                  style: GoogleFonts.poppins(
                                      color: Color(0xFFFF9228))),
                            ),
                          SizedBox(width: 20),
                          GestureDetector(
                            onTap: () {
                              int educationId = education["id"];
                              navigateToEditEducation(
                                  true, educationId, education);
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
                itemCount: _educationController.educationDetails.length);
          }
        });
  }

  void navigateToEditEducation(
      bool isediting, int? eduId, Map<String, dynamic>? edu) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => JobSeekerCreateSecond(
                isediting: isediting, educationid: eduId, education: edu)));
  }
}
