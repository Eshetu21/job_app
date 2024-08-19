// ignore_for_file: prefer_const_constructors, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Controllers/JobSeeker/skill_controller.dart';
import 'package:job_app/Screens/JobSeeker/Jobseeker/job_seeker_skill.dart';

class FetchSkill extends StatefulWidget {
  const FetchSkill({super.key});

  @override
  State<FetchSkill> createState() => _FetchSkillState();
}

class _FetchSkillState extends State<FetchSkill> {
  final SkillController _skillController = Get.put(SkillController());
  List<String> selectedSkills = [];
  @override
  void initState() {
    super.initState();
    fetchSkills();
  }

  Future<void> fetchSkills() async {
    await _skillController.showskills();
    if (mounted) {
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
        print("selectedSkills $selectedSkills");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text("Skills", style: GoogleFonts.poppins(fontSize: 18)),
            Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => JobSeekerSkill()));
              },
              child: Text("Edit",
                  style: GoogleFonts.poppins(color: Color(0xFFFF9228))),
            )
          ],
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: Wrap(
              spacing: 8,
              children: selectedSkills.map((skill) {
                return Chip(
                  backgroundColor: Color(0xFFFF9228).withOpacity(0.7),
                  labelPadding: EdgeInsets.symmetric(horizontal: 0),
                  label: Text(skill,
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontSize: 12)),
                  deleteIcon: Icon(Icons.close, size: 16),
                );
              }).toList()),
        ),
      ],
    );
  }
}
