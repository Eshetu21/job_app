// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Controllers/JobSeeker/language_controller.dart';
import 'package:job_app/Screens/JobSeeker/Jobseeker/jobseeker_profile.dart';

class JobSeekerLanguage extends StatefulWidget {
  const JobSeekerLanguage({super.key});

  @override
  State<JobSeekerLanguage> createState() => _JobSeekerLanguageState();
}

class _JobSeekerLanguageState extends State<JobSeekerLanguage> {
  final box = GetStorage();
  final Languagecontroller _languagecontroller = Get.put(Languagecontroller());
  List<dynamic> lnguages = [];
  List<dynamic> fetchedLanguages = <dynamic>[];
  List<String> selectedLanguages = [];
  String? selectedLanguage;
  @override
  void initState() {
    super.initState();
    fetchSkills();
    loadSkills();
  }

  Future<void> fetchSkills() async {
    await _languagecontroller.showlanguages();
    setState(() {
      var fetchedLanguages = _languagecontroller.languages;
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

  Future<void> loadSkills() async {
    final String response =
        await rootBundle.loadString('assets/json/languages.json');
    final data = await json.decode(response);
    setState(() {
      lnguages = data['languages'];
    });
  }

  void _addLanguage(String language) {
    setState(() {
      if (!selectedLanguages.contains(language) &&
          selectedLanguages.length < 5) {
        selectedLanguages.add(language);
      }
    });
  }

  void _removeSkill(String language) {
    setState(() {
      selectedLanguages.remove(language);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add your languages',
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'This will help you get discovered by clients based on your languages',
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
              ),
              SizedBox(height: 16),
              Text('Write a language (5 Max)',
                  style: GoogleFonts.poppins(fontSize: 14)),
              SizedBox(height: 15),
              DropdownButton<String>(
                  hint: Text("Select language", style: GoogleFonts.poppins()),
                  value: selectedLanguage,
                  items: lnguages.map((language) {
                    return DropdownMenuItem<String>(
                        value: language,
                        child: Text(language, style: GoogleFonts.poppins()));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedLanguage = value;
                      if (value != null) {
                        _addLanguage(value);
                      }
                    });
                  }),
              Wrap(
                  spacing: 2,
                  children: selectedLanguages.map((skill) {
                    return Chip(
                      backgroundColor: Color(0xFFFF9228).withOpacity(0.7),
                      labelPadding: EdgeInsets.symmetric(horizontal: 0),
                      label: Text(skill,
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontSize: 12)),
                      deleteIcon: Icon(Icons.close, size: 16),
                      onDeleted: () => _removeSkill(skill),
                    );
                  }).toList()),
              Spacer(),
              Center(
                child: GestureDetector(
                  onTap: () {
                    int jobseekerId = box.read("jobseekerId");
                    _languagecontroller.updatelanguages(
                        jobseekerId: jobseekerId, Languages: selectedLanguages);
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    width: 266,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xFF130160),
                    ),
                    child: Center(
                      child: Text("SAVE",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                  ),
                ),
              ),
              Obx(() {
                if (_languagecontroller.updatedSucsessfully.value == true) {
                  Future.delayed(Duration.zero, () {
                    sucessfullyUpdated(context);
                  });
                }
                return SizedBox.shrink();
              })
            ],
          ),
        ),
      ),
    );
  }

  void sucessfullyUpdated(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Success", style: GoogleFonts.poppins()),
              content: Text("Language updated sucessfully",
                  style: GoogleFonts.poppins()),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: ((context) => JobseekerProfile())));
                      _languagecontroller.updatedSucsessfully.value = false;
                    },
                    child: Text(
                      "Ok",
                      style: GoogleFonts.poppins(),
                    ))
              ],
            ));
  }
}
