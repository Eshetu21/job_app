// ignore_for_file: avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class JobSeekerSkill extends StatefulWidget {
  const JobSeekerSkill({super.key});

  @override
  State<JobSeekerSkill> createState() => _SkillState();
}

class _SkillState extends State<JobSeekerSkill> {
  List<dynamic> skills = [];
  List<String> selectedSkills = [];
  String? selectedSkill;

  @override
  void initState() {
    super.initState();
    loadSkills();
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
              hint: Text("Select skill",style: GoogleFonts.poppins()),
              value: selectedSkill,
              items: skills.map((skill){
                return DropdownMenuItem<String>(
                  value: skill,
                  child: Text(skill,style: GoogleFonts.poppins()));
              }).toList(), onChanged: (value){
                setState(() {
                  selectedSkill=value;
                  if(value!=null){
                    _addSkill(value);
                  }
                });
              }),
              Wrap(
                spacing: 5,
                children: selectedSkills.map((skill){
                  return Chip(
                    label: Text(skill),
                    deleteIcon: Icon(Icons.close),
                    onDeleted: () => _removeSkill(skill),
                    );
                }).toList()
                 
              )
            ],
          ),
        ),
      ),
    );
  }
}
