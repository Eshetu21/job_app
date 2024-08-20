// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Controllers/JobSeeker/language_controller.dart';
import 'package:job_app/Screens/JobSeeker/Jobseeker/job_seeker_language.dart';

class FetchLanguage extends StatefulWidget {
  const FetchLanguage({super.key});

  @override
  State<FetchLanguage> createState() => _FetchLanguageState();
}

class _FetchLanguageState extends State<FetchLanguage> {
  final Languagecontroller _languageController = Get.put(Languagecontroller());
  List<String> selectedLanguages = [];
  @override
  void initState() {
    super.initState();
    fetchLanguages();
  }

  Future<void> fetchLanguages() async {
    await _languageController.showlanguages();
    if (mounted) {
      setState(() {
        var fetchedLanguages = _languageController.languages;
        if (fetchedLanguages.isNotEmpty) {
          var selectedString = fetchedLanguages.toString();
          if (selectedString.length > 6) {
            var selectedSub =
                selectedString.substring(3, selectedString.length - 3);
            print("selectedSub $selectedSub");
            List<String> LanguageList =
                selectedSub.split('","').map((skill) => skill.trim()).toList();
            selectedLanguages.addAll(LanguageList);
          } else {
            print("string too short");
          }
        }
        print("fetchedLanguages $fetchedLanguages");
        print("selectedLanguages $selectedLanguages");
        print(_languageController.languages);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text("Languages", style: GoogleFonts.poppins(fontSize: 18)),
            Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => JobSeekerLanguage()));
              },
              child: Text(
                  _languageController.languages.isEmpty ? "Add" : "Edit",
                  style: GoogleFonts.poppins(color: Color(0xFFFF9228))),
            )
          ],
        ),
        _languageController.languages.isEmpty
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
                future: _languageController.showlanguages(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return Container(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                        spacing: 8,
                        children: selectedLanguages.map((skill) {
                          return Chip(
                            backgroundColor: Color(0xFFFF9228).withOpacity(0.7),
                            labelPadding: EdgeInsets.symmetric(horizontal: 0),
                            label: Text(skill,
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
