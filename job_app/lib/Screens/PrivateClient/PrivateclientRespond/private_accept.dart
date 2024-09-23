// ignore_for_file: prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Controllers/PrivateClient/privateclient_controller.dart';

class PrivateAccept extends StatefulWidget {
  final Map application;
  const PrivateAccept({super.key, required this.application});

  @override
  State<PrivateAccept> createState() => _PrivateAcceptState();
}

class _PrivateAcceptState extends State<PrivateAccept> {
  final PrivateclientController _privateclientController =
      Get.put(PrivateclientController());
  final TextEditingController _statementController = TextEditingController();
  void validateAndSubmit() async {
    bool hasError = false;
    if (_statementController.text.trim().isEmpty) {
      hasError = true;
      _privateclientController.acceptError["empty"] = "statement is required";
    }
    if (!hasError) {
      int appId = widget.application["application_id"];
      int jobId = widget.application["job"]["id"];
      bool verifyAcceptance = await _privateclientController.acceptApplication(
          jobId: jobId, appId: appId, statement: _statementController.text);
      if (verifyAcceptance) {
        Fluttertoast.showToast(
            msg: "Sucessfully Accepted",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 4,
            backgroundColor: Color(0xFF130160),
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _privateclientController.acceptError.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(20),
        child: Obx(() {
          String? emptyError = _privateclientController.acceptError["empty"];
          String? Error = _privateclientController.acceptError["message"];
          return Column(
            children: [
              Text(
                  "Write a response indicating that the job posting has been accepted.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      color: Color(0xFF524B6B), fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              TextFormField(
                controller: _statementController,
                maxLines: 8,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    hintText: "Write your response here",
                    hintStyle: GoogleFonts.poppins()),
              ),
              SizedBox(
                height: 5,
              ),
              emptyError != null
                  ? Text(
                      emptyError,
                      style: GoogleFonts.poppins(color: Colors.red),
                    )
                  : Container(),
              Error != null
                  ? Text(Error, style: GoogleFonts.poppins(color: Colors.red))
                  : Container(),
              SizedBox(height: 20),
              Obx(() {
                return GestureDetector(
                  onTap: () {
                    _privateclientController.acceptError.clear();
                    validateAndSubmit();
                  },
                  child: Container(
                    width: 266,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xFF130160),
                    ),
                    child: Center(
                        child: _privateclientController.acceptLoading.value
                            ? Center(
                                child: CircularProgressIndicator(
                                strokeWidth: 2,
                                strokeAlign: -5,
                                color: Colors.white,
                              ))
                            : Text("Submit",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white))),
                  ),
                );
              })
            ],
          );
        }),
      )),
    );
  }
}
