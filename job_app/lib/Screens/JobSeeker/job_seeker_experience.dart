// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Screens/JobSeeker/job_seeker_pic.dart';
import 'package:job_app/Widgets/JobSeeker/build_text_form.dart';

class JobSeekerExperience extends StatefulWidget {
  const JobSeekerExperience({super.key});

  @override
  State<JobSeekerExperience> createState() => _JobSeekerExperienceState();
}

class _JobSeekerExperienceState extends State<JobSeekerExperience> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                Text(
                  "Add work experience",
                  style: GoogleFonts.poppins(
                      color: Color(0xFF150B3D),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                    "Highlight your professional journey by detailing your work experience, including the positions you've held and the skills you've gained.",style: GoogleFonts.poppins()),
                SizedBox(height: 20),
                buildTextFormField("Job Title", _titleController),
                SizedBox(height: 10),
                buildTextFormField("Comapny", _companyController),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: buildDateField("Start Date", _startController),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: buildDateField("End Date", _endController),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                buildTextFormField("Description", _descriptionController),
                SizedBox(height: 20),
                Center(
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: EdgeInsets.only(top: 40, bottom: 20),
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
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => JobSeekerPicture()));
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
}
