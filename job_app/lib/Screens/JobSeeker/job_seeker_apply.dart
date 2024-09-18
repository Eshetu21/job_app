// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JobSeekerApply extends StatefulWidget {
  const JobSeekerApply({super.key});

  @override
  State<JobSeekerApply> createState() => _JobSeekerApplyState();
}

class _JobSeekerApplyState extends State<JobSeekerApply> {
  final _formKey = GlobalKey<FormState>();
  String? _coverLetter;
  String? _cv;

  Future<void> _pickCoverLetter() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _coverLetter = result.files.single.name;
      });
    }
  }

  Future<void> _pickCv() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _cv = result.files.single.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Container(
              margin: EdgeInsets.all(40),
              child: Column(
                children: [
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.arrow_back),
                              SizedBox(width: 40),
                              Text("Apply here",
                                  style: GoogleFonts.poppins(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0D0140))),
                            ],
                          ),
                          SizedBox(height: 15),
                          Text(
                              "To apply for a job, you need to upload your CV and Cover letter",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(color: Color(0xFF524B6B))),
                          SizedBox(height: 20),
                          TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                                labelText: "Cover Letter",
                                suffixIcon: IconButton(
                                    onPressed: _pickCoverLetter,
                                    icon: Icon(Icons.file_upload))),
                            controller: TextEditingController(text: _coverLetter),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Cover letter is required';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                                labelText: "CV",
                                suffixIcon: IconButton(
                                    onPressed: _pickCv,
                                    icon: Icon(Icons.file_upload))),
                            controller: TextEditingController(text: _cv),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'CV is required';
                              }
                              return null;
                            },
                          )
                        ],
                      )),
                ],
              )),
        ));
  }
}
