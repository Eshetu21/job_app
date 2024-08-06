// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Controllers/JobSeeker/JobSeekerController.dart';
import 'package:job_app/Controllers/User/UserController.dart';
import 'package:job_app/Screens/JobSeeker/job_seeker_create.dart';

class AddAccount extends StatefulWidget {
  const AddAccount({super.key});

  @override
  State<AddAccount> createState() => _AddAccountState();
}

final UserAuthenticationController _userAuthenticationController =
    Get.put(UserAuthenticationController());
final JobSeekerController _jobSeekerController = Get.put(JobSeekerController());
String selected = '';

class _AddAccountState extends State<AddAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFE5E5E5),
        body: SafeArea(
            child: Container(
          margin: EdgeInsets.only(top: 30, left: 25, right: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Setup your first profile",
                    style: GoogleFonts.poppins(
                        color: Color(0xFF0D0140),
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                  GestureDetector(
                    onTap: () {
                      _userAuthenticationController.logout();
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.logout_outlined,
                          color: Color(0xFF130160),
                          size: 18,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text("LOG OUT",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF130160))),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Text(
                "You can have multiple profiles by adding new profiles and switching between them easily",
                style:
                    GoogleFonts.poppins(color: Color(0xFF0D0140), fontSize: 15),
              ),
              SizedBox(height: 30),
              _profileContainer(
                  ListTile(
                    leading: Image.asset("assets/icons/job_seeker.png",
                        width: 23, color: Color(0xFFFF9228).withOpacity(0.4)),
                    title: Text("Job Seeker",
                        style: GoogleFonts.poppins(
                          color: Color(0xFF0D0140),
                        )),
                    trailing: Radio(
                        value: "jobseeker",
                        groupValue: selected,
                        onChanged: (value) {
                          setState(() {
                            selected = value.toString();
                          });
                        }),
                  ),
                  "jobseeker"),
              _profileContainer(
                  ListTile(
                    leading: Image.asset("assets/icons/private.png",
                        width: 23, color: Color(0xFFFF9228).withOpacity(0.4)),
                    title: Text("Private Client",
                        style: GoogleFonts.poppins(
                          color: Color(0xFF0D0140),
                        )),
                    trailing: Radio(
                        value: "privateclient",
                        groupValue: selected,
                        onChanged: (value) {
                          setState(() {
                            selected = value.toString();
                          });
                        }),
                  ),
                  "privateclient"),
              _profileContainer(
                  ListTile(
                    leading: Image.asset("assets/icons/company.png",
                        width: 23, color: Color(0xFFFF9228).withOpacity(0.4)),
                    title: Text("Company",
                        style: GoogleFonts.poppins(
                          color: Color(0xFF0D0140),
                        )),
                    trailing: Radio(
                        value: "company",
                        groupValue: selected,
                        onChanged: (value) {
                          setState(() {
                            selected = value.toString();
                          });
                        }),
                  ),
                  "company"),
              SizedBox(height: 120),
              GestureDetector(
                onTap: () async {
                  if (selected == 'jobseeker')
                  await _jobSeekerController.createjobseeker();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => JobSeekerCreate()));
                },
                child: Center(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 60),
                    width: 266,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xFF130160).withOpacity(0.7),
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
        )));
  }

  Widget _profileContainer(Widget child, String value) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selected = value;
        });
      },
      child: Container(
        margin: EdgeInsets.all(11),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: Offset(0, 2))
            ]),
        child: child,
      ),
    );
  }
}
