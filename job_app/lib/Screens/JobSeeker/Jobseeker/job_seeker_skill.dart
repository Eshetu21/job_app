// ignore_for_file: avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_final_fields

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Controllers/JobSeeker/skill_controller.dart';
import 'package:job_app/Screens/JobSeeker/Jobseeker/jobseeker_profile.dart';

class JobSeekerSkill extends StatefulWidget {
  const JobSeekerSkill({super.key});

  @override
  State<JobSeekerSkill> createState() => _SkillState();
}

class _SkillState extends State<JobSeekerSkill> {
  SkillController _skillController = Get.put(SkillController());
  List<dynamic> skills = [];
  List<dynamic> fetchedSkills = <dynamic>[];
  List<String> selectedSkills = [];
  String? selectedSkill;

  @override
  void initState() {
    super.initState();
    loadSkills();
    fetchSkills();
  }
  Future refreshSkills()async{
    
  }
  Future<void> fetchSkills() async {
    await _skillController.showskills();
    setState(() {
      var fetchedSkills = _skillController.skills;
      if (fetchedSkills.isNotEmpty) {
        var selectedString = fetchedSkills.toString();
        var selectedSub =
            selectedString.substring(3, selectedString.length - 3);
        List<String> skillList =
            selectedSub.split('","').map((skill) => skill.trim()).toList();
        selectedSkills.addAll(skillList);
      }
    });
  }

  Future<void> loadSkills() async {
    final String response =
        await rootBundle.loadString('assets/json/skills.json');
    final data = await json.decode(response);
    setState(() {
      skills = data['skills'];
    });
  }

  void _addSkill(String skill) {
    setState(() {
      if (!selectedSkills.contains(skill) && selectedSkills.length < 10) {
        selectedSkills.add(skill);
      }
    });
  }

  void _removeSkill(String skill) {
    setState(() {
      selectedSkills.remove(skill);
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
                'Add your skills',
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'This will help you get discovered by clients based on your skills',
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
              ),
              SizedBox(height: 16),
              Text('Choose a skill (10 Max)',
                  style: GoogleFonts.poppins(fontSize: 14)),
              SizedBox(height: 15),
              DropdownButton<String>(
                  hint: Text("Select skill", style: GoogleFonts.poppins()),
                  value: selectedSkill,
                  items: skills.map((skill) {
                    return DropdownMenuItem<String>(
                        value: skill,
                        child: Text(skill, style: GoogleFonts.poppins()));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSkill = value;
                      if (value != null) {
                        _addSkill(value);
                      }
                    });
                  }),
              Wrap(
                  spacing: 2,
                  children: selectedSkills.map((skill) {
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
                    final box = GetStorage();
                    int jobseekerId = box.read("jobseekerId");
                    _skillController.addskills(
                        id: jobseekerId, skills: selectedSkills);
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    width: 266,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xFF130160).withOpacity(0.7),
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
                if (_skillController.updatedSucsessfully.value == true) {
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
              content: Text("Skills updated sucessfully",
                  style: GoogleFonts.poppins()),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: ((context) => JobseekerProfile())));
                      _skillController.updatedSucsessfully.value = false;
                    },
                    child: Text(
                      "Ok",
                      style: GoogleFonts.poppins(),
                    ))
              ],
            ));
  }
}
