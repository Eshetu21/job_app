// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

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
        body: Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(20),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
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
                ))));
  }
}
