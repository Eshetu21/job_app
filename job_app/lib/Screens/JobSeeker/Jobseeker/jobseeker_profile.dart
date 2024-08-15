// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Controllers/Profile/ProfileController.dart';
import 'package:job_app/Screens/JobSeeker/Jobseeker/Edit%20Jobseeker/edit_education.dart';
import 'package:job_app/Screens/JobSeeker/Jobseeker/Edit%20Jobseeker/job_seeker_skill.dart';

class JobseekerProfile extends StatefulWidget {
  const JobseekerProfile({super.key});

  @override
  State<JobseekerProfile> createState() => _JobseekerProfileState();
}

class _JobseekerProfileState extends State<JobseekerProfile> {
  final ProfileController _profileController = Get.put(ProfileController());
  var refreshkey = GlobalKey<RefreshIndicatorState>();
  final box = GetStorage();
  late RxList<String> selectedSkills;

  @override
  void initState() {
    super.initState();

    List<dynamic>? storedList = box.read<List<dynamic>>("selectedList");
    if (storedList != null) {
      selectedSkills = RxList<String>(storedList.cast<String>());
    } else {
      selectedSkills = RxList<String>();
    }
    _profileController.fetchProfiles();
  }

  @override
  Widget build(BuildContext context) {
    print(box.read("selectedList"));
    return Scaffold(
        body: SafeArea(
            child: FutureBuilder(
                future: _profileController.fetchProfiles(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error"));
                  }
                  if (_profileController.profiles.isEmpty) {
                    return Center(
                      child: Text("No profile data found",
                          style: GoogleFonts.poppins()),
                    );
                  } else {
                    return SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.all(20),
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                    radius: 45,
                                    backgroundColor:
                                        Colors.grey.withOpacity(0.2),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                              _profileController
                                                      .profiles["jobseeker"]
                                                  ["user"]["firstname"][0],
                                              style: GoogleFonts.poppins(
                                                  fontSize: 45)),
                                          Text(
                                              _profileController
                                                      .profiles["jobseeker"]
                                                  ["user"]["lastname"][0],
                                              style: GoogleFonts.poppins(
                                                  fontSize: 45)),
                                        ])),
                                SizedBox(height: 12),
                                _profileController.isloading.value
                                    ? Text("loading...")
                                    : Text(
                                        _profileController.profiles["jobseeker"]
                                                ["user"]["firstname"] +
                                            " " +
                                            _profileController
                                                    .profiles["jobseeker"]
                                                ["user"]["lastname"],
                                        style: GoogleFonts.poppins()),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.location_on_outlined, size: 20),
                                    _profileController.profiles["jobseeker"]
                                                ["user"]["address"] !=
                                            null
                                        ? Text(
                                            _profileController
                                                    .profiles["jobseeker"]
                                                ["user"]["address"],
                                            style: GoogleFonts.poppins(),
                                          )
                                        : Text("Null",
                                            style: GoogleFonts.poppins()),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.email_outlined, size: 20),
                                    _profileController.profiles["jobseeker"]
                                                ["user"]["email"] !=
                                            null
                                        ? Text(
                                            _profileController
                                                    .profiles["jobseeker"]
                                                ["user"]["email"],
                                            style: GoogleFonts.poppins(),
                                          )
                                        : Text("Null",
                                            style: GoogleFonts.poppins()),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Divider(),
                          Container(
                            margin: EdgeInsets.all(12),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text("Skills",
                                        style:
                                            GoogleFonts.poppins(fontSize: 18)),
                                    Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    JobSeekerSkill()));
                                      },
                                      child: Text("Edit",
                                          style: GoogleFonts.poppins(
                                              color: Color(0xFFFF9228))),
                                    )
                                  ],
                                ),
                                SizedBox(height: 5),
                                Wrap(
                                    spacing: 8,
                                    children: selectedSkills.value.map((skill) {
                                      return Chip(
                                        backgroundColor:
                                            Color(0xFFFF9228).withOpacity(0.7),
                                        labelPadding:
                                            EdgeInsets.symmetric(horizontal: 0),
                                        label: Text(skill,
                                            style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontSize: 12)),
                                        deleteIcon: Icon(Icons.close, size: 16),
                                      );
                                    }).toList()),
                                Divider(),
                                Row(
                                  children: [
                                    Text("Education",
                                        style:
                                            GoogleFonts.poppins(fontSize: 18)),
                                    Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditEducation()));
                                      },
                                      child: Text("Edit",
                                          style: GoogleFonts.poppins(
                                              color: Color(0xFFFF9228))),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                })));
  }
}
