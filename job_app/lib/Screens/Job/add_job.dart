// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Widgets/JobSeeker/build_text_form.dart';

class AddJob extends StatefulWidget {
  const AddJob({super.key});

  @override
  State<AddJob> createState() => _AddJobState();
}

class _AddJobState extends State<AddJob> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _site = TextEditingController();
  final TextEditingController _type = TextEditingController();
  final TextEditingController _sector = TextEditingController();
  final TextEditingController _gender = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final TextEditingController _location = TextEditingController();
  final TextEditingController _salary = TextEditingController();
  final TextEditingController _deadline = TextEditingController();
  final TextEditingController _description = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              margin: EdgeInsets.only(right: 25, left: 25, bottom: 25, top: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "New Job Post",
                    style: GoogleFonts.poppins(
                        color: Color(0xFF150B3D),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  buildTextFormField("Job title", _title),
                  SizedBox(height: 8),
                  buildTextFormField("Job site", _site),
                  SizedBox(height: 8),
                  buildTextFormField("Job type", _type),
                  SizedBox(height: 8),
                  buildTextFormField("Job sector", _sector),
                  SizedBox(height: 8),
                  buildTextFormField("City", _city),
                  SizedBox(height: 8),
                  buildTextFormField("Gender", _gender),
                  SizedBox(height: 8),
                  buildTextFormField("Job location", _location),
                  SizedBox(height: 8),
                  buildTextFormField("Salary", _salary),
                  SizedBox(height: 8),
                  buildDateField("Deadline", _deadline),
                  SizedBox(height: 8),
                  buildTextFormField("Description", _description),
                  SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: () async {},
                      child: Container(
                        margin: EdgeInsets.only(top: 30, bottom: 20),
                        width: 266,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color(0xFF130160).withOpacity(0.7),
                        ),
                        child: Center(
                          child: Text("POST",
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
      ),
    );
  }

  void sucessfullyUpdated(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Success", style: GoogleFonts.poppins()),
              content: Text("Education updated sucessfully",
                  style: GoogleFonts.poppins()),
              actions: [
                TextButton(
                    onPressed: () {},
                    child: Text(
                      "Ok",
                      style: GoogleFonts.poppins(),
                    ))
              ],
            ));
  }
}
