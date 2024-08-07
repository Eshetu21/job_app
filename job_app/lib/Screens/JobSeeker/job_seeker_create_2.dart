// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Controllers/JobSeeker/education_controller.dart';

class JobSeekerCreateSecond extends StatefulWidget {
  const JobSeekerCreateSecond({super.key});

  @override
  State<JobSeekerCreateSecond> createState() => _JobSeekerCreateSecondState();
}

class _JobSeekerCreateSecondState extends State<JobSeekerCreateSecond> {
  final EducationController _educationController =
      Get.put(EducationController());
  var educationDetails = {};
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    fetchEducationDetails();
  }

  Future<Map<String, dynamic>> fetchEducationDetails() async {
    final jobseekerid = box.read("jobseekerId");
    var details =
        await _educationController.showeducation(jobseekerId: jobseekerid);
    setState(() {
      educationDetails = details;
    });
    return details;
  }

  @override
  Widget build(BuildContext context) {
    print(educationDetails);
    return Scaffold(
      backgroundColor: Color(0xFFE5E5E5),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.only(right: 25, left: 25, bottom: 25, top: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Add Education",
                  style: GoogleFonts.poppins(
                      color: Color(0xFF150B3D),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                _buildTextField("Institution name"),
                SizedBox(height: 10),
                _buildTextField("Level of education"),
                SizedBox(height: 10),
                _buildTextField("Field of study"),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField("Start Date"),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: _buildTextField("End Date"),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                _buildTextField("Description"),
                SizedBox(height: 40),
                Center(
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20),
                      width: 266,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xFF130160).withOpacity(0.7),
                      ),
                      child: Center(
                        child: Text("SAVE",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {},
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
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Color(0xFF150B3D),
            fontSize: 14,
          ),
        ),
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white.withOpacity(0.5)),
          child: TextField(
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(10),
                hintText: "",
                hintStyle:
                    TextStyle(fontFamily: GoogleFonts.poppins().fontFamily)),
          ),
        ),
      ],
    );
  }
}
