// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Controllers/JobSeeker/education_controller.dart';


class ViewEducation extends StatefulWidget {
  const ViewEducation({super.key});

  @override
  State<ViewEducation> createState() => _ViewEducationState();
}

class _ViewEducationState extends State<ViewEducation> {
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
                    Text("Education",
                        style: GoogleFonts.poppins(
                            fontSize: 20, fontWeight: FontWeight.bold)),
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
                  var education = _educationController.educationDetails[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Education",
                          style: GoogleFonts.poppins(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Column(
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
                        ],
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
}
