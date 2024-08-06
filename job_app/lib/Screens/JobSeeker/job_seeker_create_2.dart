// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class JobSeekerCreateSecond extends StatefulWidget {
  const JobSeekerCreateSecond({super.key});

  @override
  State<JobSeekerCreateSecond> createState() => _JobSeekerCreateSecondState();
}

class _JobSeekerCreateSecondState extends State<JobSeekerCreateSecond> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE5E5E5),
      body: SafeArea(child: Text("second page")),
    );
  }
}
