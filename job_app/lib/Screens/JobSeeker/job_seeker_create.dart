// ignore_for_file: prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, prefer_const_constructors, curly_braces_in_flow_control_structures, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Controllers/JobSeeker/jobseeker_controller.dart';
import 'package:job_app/Screens/JobSeeker/job_seeker_education.dart';

class JobSeekerCreate extends StatefulWidget {
  const JobSeekerCreate({super.key});

  @override
  State<JobSeekerCreate> createState() => _JobSeekerCreateState();
}

class _JobSeekerCreateState extends State<JobSeekerCreate> {
  final JobSeekerController _jobSeekerController =
      Get.put(JobSeekerController());
  final box = GetStorage();
  List<dynamic> categories = [];
  List<dynamic> subcategories = [];
  String? selectedCategory;
  String? selectedSubcategory;

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  Future<void> loadCategories() async {
    final String response =
        await rootBundle.loadString('assets/json/categories.json');
    final data = await json.decode(response);
    setState(() {
      categories = data['categories'];
    });
  }

  void updateSubcategories(String? category) {
    setState(() {
      subcategories = category != null
          ? categories.firstWhere(
              (element) => element['category'] == category)['subcategories']
          : [];
      selectedSubcategory = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Tell as about your work",
                  style: GoogleFonts.poppins(
                      fontSize: 20, fontWeight: FontWeight.w500)),
              SizedBox(height: 10),
              Text(
                  "Relevant services you provide can help your profile stand out. Choose a category that best describes the type of work you do"),
              SizedBox(height: 20),
              Text("Main Service"),
              SizedBox(height: 26),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                    labelText: 'Select Category',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18))),
                value: selectedCategory,
                items: categories.map<DropdownMenuItem<String>>((category) {
                  return DropdownMenuItem<String>(
                    value: category['category'],
                    child: Text(
                      category['category'],
                      style: GoogleFonts.poppins(),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                    updateSubcategories(value);
                  });
                },
              ),
              SizedBox(height: 26),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                    labelText: 'Select Subcategory',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18))),
                value: selectedSubcategory,
                items:
                    subcategories.map<DropdownMenuItem<String>>((subcategory) {
                  return DropdownMenuItem<String>(
                    value: subcategory,
                    child: Text(
                      subcategory,
                      style: GoogleFonts.poppins(),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedSubcategory = value;
                  });
                },
              ),
              SizedBox(height: 160),
              GestureDetector(
                onTap: () async {
                  await _jobSeekerController.updatejobseeker(
                    category: selectedCategory!,
                    subCategory: selectedSubcategory!,
                  );
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => JobSeekerCreateSecond()));
                },
                child: Center(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 60),
                    width: 266,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xFF130160),
                    ),
                    child: Center(
                      child: Text("Continue",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
