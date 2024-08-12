// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, avoid_unnecessary_containers, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Controllers/JobSeeker/JobSeekerController.dart';
import 'package:job_app/Controllers/Profile/ProfileController.dart';

class JobSeekerHomepage extends StatefulWidget {
  const JobSeekerHomepage({super.key});

  @override
  State<JobSeekerHomepage> createState() => _JobSeekerHomepageState();
}

class _JobSeekerHomepageState extends State<JobSeekerHomepage> {
  final JobSeekerController _jobSeekerController =
      Get.put(JobSeekerController());
  final ProfileController _profileController = Get.put(ProfileController());
  String selectedProfile = '';
  @override
  void initState() {
    super.initState();
    _jobSeekerController.getJobSeeker();
    _jobSeekerController.fetchJobSeeker();
  }

  @override
  Widget build(BuildContext context) {
    print(_jobSeekerController.jobseeker);
    return Scaffold(
        backgroundColor: Color(0xFFE5E5E5),
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text("Welcome",
                        style: GoogleFonts.poppins(
                            fontSize: 24, color: Color(0xFFFF9228))),
                    Spacer(),
                    Icon(Icons.settings_rounded),
                    SizedBox(width: 10),
                    Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: GestureDetector(
                          onTap: (){
                            showModalBottomSheet(context: context,
                            backgroundColor: Colors.white.withOpacity(0.7),
                             builder: (context){
                              if(_profileController.isloading.value){
                                return CircularProgressIndicator();
                              }
                              else{
                                return Container(
                                  child: Column(
                                    children: [
                                      if(_profileController.profiles["jobseeker"]!=null)
                                      ListTile(),
                                    ],
                                  ),
                                );
                              }
                            });
                          },
                          child: Image.asset("assets/icons/switch.png")),
                    )
                  ],
                ),
                Obx(() {
                  if (_jobSeekerController.jobseeker.isEmpty) {
                    return FutureBuilder(
                        future: _jobSeekerController.getJobSeeker(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text("Error ${snapshot.error}");
                          } else if (snapshot.hasData) {
                            var jobseekerData =
                                snapshot.data as Map<String, dynamic>;
                            _jobSeekerController.jobseeker.value =
                                jobseekerData;
                            String firstname =
                                jobseekerData["jobseeker"]["user"]["firstname"];
                            return Text(
                              firstname,
                            );
                          } else {
                            return Text("No data found");
                          }
                        });
                  } else {
                    var jobSeekerData = _jobSeekerController.jobseeker.value;
                    String firstname =
                        jobSeekerData["jobseeker"]["user"]["firstname"];
                    return Text(firstname,
                        style: GoogleFonts.poppins(fontSize: 20));
                  }
                }),
                SizedBox(height: 15),
                TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none),
                      hintText: "Search for jobs...",
                      hintStyle: GoogleFonts.poppins(),
                      prefixIcon: Icon(Icons.search_outlined),
                      fillColor: Colors.white.withOpacity(0.7),
                      filled: true),
                )
              ],
            ),
          ),
        ));
  }

  Widget _profileContainer(Widget child, String value) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedProfile = value;
        });
      },
      child: Container(
        margin: EdgeInsets.all(12),
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
