// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:job_app/Screens/PrivateClient/PrivateclientView/viewEducation.dart';
import 'package:job_app/Screens/PrivateClient/PrivateclientView/viewExperience.dart';
import 'package:job_app/Screens/PrivateClient/PrivateclientView/viewLanguage.dart';
import 'package:job_app/Screens/PrivateClient/PrivateclientView/viewProfile.dart';
import 'package:job_app/Screens/PrivateClient/PrivateclientView/viewSkill.dart';

class PrivateViewProfile extends StatefulWidget {
  final Map jobseeker;
  const PrivateViewProfile({super.key, required this.jobseeker});

  @override
  State<PrivateViewProfile> createState() => _PrivateViewProfileState();
}

class _PrivateViewProfileState extends State<PrivateViewProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Padding(padding: EdgeInsets.all(15), child: ViewProfile()),
            Card(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: EdgeInsets.all(15),
                child: ViewEducation(),
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 10),
              child:
                  Padding(padding: EdgeInsets.all(15), child: ViewExperience()),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Padding(padding: EdgeInsets.all(15), child: ViewSkill()),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 10),
              child:
                  Padding(padding: EdgeInsets.all(15), child: ViewLanguage()),
            ),
          ],
        ),
      ),
    )));
  }
}
