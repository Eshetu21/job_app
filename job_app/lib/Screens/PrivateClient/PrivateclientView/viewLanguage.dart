// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Controllers/JobSeeker/language_controller.dart';
import 'package:job_app/Controllers/PrivateClient/privateclient_controller.dart';

class ViewLanguage extends StatefulWidget {
  final Map applicant;
  const ViewLanguage({super.key, required this.applicant});

  @override
  State<ViewLanguage> createState() => _ViewLanguageState();
}

class _ViewLanguageState extends State<ViewLanguage> {
  final PrivateclientController _privateclientController =
      Get.put(PrivateclientController());
  List<String> selectedLanguages = [];
  @override
  void initState() {
    super.initState();
    fetchLanguages();
  }

  Future<void> fetchLanguages() async {
    await _privateclientController.getJobSeeker(
        jobSeekerId: widget.applicant["jobseeker"]["id"]);
    if (mounted) {
      setState(() {
        var fetchedLanguages = _privateclientController.languages;
        if (fetchedLanguages.isNotEmpty) {
          var selectedString = fetchedLanguages.toString();
          if (selectedString.length > 6) {
            var selectedSub =
                selectedString.substring(3, selectedString.length - 3);
            List<String> LanguageList =
                selectedSub.split('","').map((skill) => skill.trim()).toList();
            selectedLanguages.addAll(LanguageList);
          } else {
            print("string too short");
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Languages",
            style:
                GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
        _privateclientController.languages.isEmpty
            ? Center(
                child: Container(
                height: 100,
                child: Column(
                  children: [
                    Icon(Icons.settings,
                        color: Color(0xFFFF9228).withOpacity(0.5), size: 50),
                    Text(
                      "No Languages",
                      style: GoogleFonts.poppins(color: Colors.grey),
                    )
                  ],
                ),
              ))
            : FutureBuilder(
                future: _privateclientController.getJobSeeker(
                    jobSeekerId: widget.applicant["jobseeker"]["id"]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return Container(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                        spacing: 3,
                        children: selectedLanguages.map((language) {
                          return Chip(
                            backgroundColor: Color(0xFFFF9228).withOpacity(0.7),
                            labelPadding: EdgeInsets.symmetric(horizontal: 0),
                            label: Text(language,
                                style: GoogleFonts.poppins(
                                    color: Colors.white, fontSize: 12)),
                            deleteIcon: Icon(Icons.close, size: 16),
                          );
                        }).toList()),
                  );
                }),
      ],
    );
  }
}
