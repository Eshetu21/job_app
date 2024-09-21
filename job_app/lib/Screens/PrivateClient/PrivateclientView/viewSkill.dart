// ignore_for_file: prefer_const_constructors, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Controllers/PrivateClient/privateclient_controller.dart';

class ViewSkill extends StatefulWidget {
  final Map applicant;
  const ViewSkill({super.key, required this.applicant});

  @override
  State<ViewSkill> createState() => _ViewSkillState();
}

class _ViewSkillState extends State<ViewSkill> {
  final PrivateclientController _privateclientController =
      Get.put(PrivateclientController());
  List<String> selectedSkills = [];
  @override
  void initState() {
    super.initState();
    fetchSkills();
  }

  Future<void> fetchSkills() async {
    await _privateclientController.getJobSeeker(
        jobSeekerId: widget.applicant["jobseeker"]["id"]);
    if (mounted) {
      setState(() {
        var fetchedSkills = _privateclientController.skills;
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
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Skills",
            style:
                GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
        _privateclientController.skills.isEmpty
            ? Center(
                child: SizedBox(
                height: 100,
                child: Column(
                  children: [
                    Icon(Icons.settings,
                        color: Color(0xFFFF9228).withOpacity(0.5), size: 50),
                    Text(
                      "No skills",
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
                  );
                }),
      ],
    );
  }
}
