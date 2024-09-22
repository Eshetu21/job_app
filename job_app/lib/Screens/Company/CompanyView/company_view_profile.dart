// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_app/Controllers/PrivateClient/privateclient_controller.dart';
import 'package:job_app/Screens/PrivateClient/PrivateclientView/viewEducation.dart';
import 'package:job_app/Screens/PrivateClient/PrivateclientView/viewExperience.dart';
import 'package:job_app/Screens/PrivateClient/PrivateclientView/viewLanguage.dart';
import 'package:job_app/Screens/PrivateClient/PrivateclientView/viewProfile.dart';
import 'package:job_app/Screens/PrivateClient/PrivateclientView/viewSkill.dart';

class CompanyViewProfile extends StatefulWidget {
  final Map applicant;
  const CompanyViewProfile({super.key, required this.applicant});

  @override
  State<CompanyViewProfile> createState() => _CompanyViewProfileState();
}

class _CompanyViewProfileState extends State<CompanyViewProfile> {
  PrivateclientController _privateclientController =
      Get.put(PrivateclientController());
  @override
  Widget build(BuildContext context) {
    _privateclientController.getJobSeeker(
        jobSeekerId: widget.applicant["jobseeker"]["id"]);
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.all(15),
                child: ViewProfile(applicant: widget.applicant)),
            Card(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: EdgeInsets.all(15),
                child: ViewEducation(
                  applicant: widget.applicant,
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                  padding: EdgeInsets.all(15),
                  child: ViewExperience(applicant: widget.applicant)),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                  padding: EdgeInsets.all(15),
                  child: ViewSkill(applicant: widget.applicant)),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                  padding: EdgeInsets.all(15),
                  child: ViewLanguage(
                    applicant: widget.applicant
                  )),
            ),
          ],
        ),
      ),
    )));
  }
}
