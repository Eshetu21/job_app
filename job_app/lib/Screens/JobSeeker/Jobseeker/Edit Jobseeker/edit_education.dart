// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_app/Controllers/JobSeeker/education_controller.dart';

class EditEducation extends StatefulWidget {
  const EditEducation({super.key});

  @override
  State<EditEducation> createState() => _EditEducationState();
}

class _EditEducationState extends State<EditEducation> {
  final EducationController _educationController =
      Get.put(EducationController());
  @override
  Widget build(BuildContext context) {
    print(_educationController.educationDetails);
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (_educationController.educationDetails.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }
          return Column(
           
          );
        }),
      ),
    );
  }
}
