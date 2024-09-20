// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Controllers/JobSeeker/apply_controller.dart';

class JobSeekerApply extends StatefulWidget {
  final int jobId;
  const JobSeekerApply({super.key, required this.jobId});

  @override
  State<JobSeekerApply> createState() => _JobSeekerApplyState();
}

class _JobSeekerApplyState extends State<JobSeekerApply> {
  final ApplyController _applyController = Get.put(ApplyController());
  final _formKey = GlobalKey<FormState>();
  String _coverLetter = '';
  String _cv = '';
  String _coverLetter1 = '';
  String _cv1 = '';

  @override
  void initState() {
    super.initState();
    _applyController.applyError.clear();
  }

  Future<void> _pickCoverLetter() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _coverLetter = result.files.single.path ?? '';
        _coverLetter1 = result.files.single.name;
      });
    }
  }

  Future<void> _pickCv() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _cv = result.files.single.path ?? '';
        _cv1 = result.files.single.name;
      });
    }
  }

  void validateAndApply() async {
    bool haserror = false;
    _applyController.applyError.clear();
    if (_coverLetter1.isEmpty || _cv1.isEmpty) {
      haserror = true;
      _applyController.applyError["empty"] =
          'Please upload all the required documents';
    }
    if (!haserror) {
      bool applySucess = await _applyController.applyJob(
          jobId: widget.jobId, coverLetter: File(_coverLetter), cv: File(_cv));
      if (applySucess) {
        sucessfullyUpdated(context);
        /*  Fluttertoast.showToast(
          msg: "Sucessfully applied stay updated for further notice",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pop(context);
        Navigator.pop(context); */
      }
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
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "To apply for a job, you need to upload your CV and Cover letter",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              color: Color(0xFF524B6B),
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      Text("Make sure each file has a maximum size of 2MB",
                          style: GoogleFonts.poppins(
                              color: Color(0xFF524B6B), fontSize: 12)),
                      SizedBox(height: 10),
                      TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                            labelText: "Cover Letter",
                            suffixIcon: IconButton(
                                onPressed: _pickCoverLetter,
                                icon: Icon(Icons.file_upload))),
                        controller: TextEditingController(text: _coverLetter1),
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
                        controller: TextEditingController(text: _cv1),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'CV is required';
                          }
                          return null;
                        },
                      )
                    ],
                  )),
              Obx(() {
                return GestureDetector(
                  onTap: () async {
                    validateAndApply();
                  },
                  child: Column(
                    children: [
                      _applyController.applyError["message"] != null
                          ? Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Text(
                                  _applyController.applyError["message"],
                                  style: GoogleFonts.poppins(
                                      color: Colors.red, fontSize: 12)),
                            )
                          : Container(),
                      _applyController.applyError["empty"] != null
                          ? Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Text(_applyController.applyError["empty"],
                                  style: GoogleFonts.poppins(
                                      color: Colors.red, fontSize: 12)),
                            )
                          : Container(),
                      Container(
                        margin: EdgeInsets.all(20),
                        width: 266,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color(0xFF130160),
                        ),
                        child: Center(
                          child: _applyController.applyLoading.value
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text("Apply",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          )),
    ));
  }

  void sucessfullyUpdated(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Success", style: GoogleFonts.poppins()),
              content: Text(
                  "Sucessfully applied stay updated for further notice",
                  style: GoogleFonts.poppins()),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Ok",
                      style: GoogleFonts.poppins(),
                    ))
              ],
            ));
  }
}
