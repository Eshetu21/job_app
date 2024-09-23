// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Controllers/PrivateClient/privateclient_controller.dart';
import 'package:job_app/Controllers/Profile/ProfileController.dart';

class PrivateProfile extends StatefulWidget {
  const PrivateProfile({super.key});

  @override
  State<PrivateProfile> createState() => _PrivateProfileState();
}

class _PrivateProfileState extends State<PrivateProfile> {
  final ProfileController _profileController = Get.put(ProfileController());
  final PrivateclientController _privateclientController =
      Get.put(PrivateclientController());

  @override
  void initState() {
    super.initState();
    _profileController.fetchProfiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: FutureBuilder(
                future: _profileController.fetchProfiles(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                      strokeWidth: 2,
                      strokeAlign: -5,
                    ));
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
                      child: Container(
                        margin: EdgeInsets.all(16),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Private Client",
                                style: GoogleFonts.poppins(fontSize: 24)),
                            SizedBox(height: 10),
                            Row(children: [
                              Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(20)),
                                  margin: EdgeInsets.only(right: 20, top: 20),
                                  padding: EdgeInsets.all(20),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                            _profileController
                                                    .profiles["jobseeker"]
                                                ["user"]["firstname"][0],
                                            style: GoogleFonts.poppins(
                                                fontSize: 50)),
                                        Text(
                                            _profileController
                                                    .profiles["jobseeker"]
                                                ["user"]["lastname"][0],
                                            style: GoogleFonts.poppins(
                                                fontSize: 50)),
                                      ])),
                              Column(
                                children: [
                                  _profileController.isloading.value
                                      ? Text("loading...")
                                      : Text(
                                          _profileController
                                                      .profiles["jobseeker"]
                                                  ["user"]["firstname"] +
                                              " " +
                                              _profileController
                                                      .profiles["jobseeker"]
                                                  ["user"]["lastname"],
                                          style: GoogleFonts.poppins(
                                              fontSize: 22)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.location_on_outlined,
                                          size: 18),
                                      _profileController.profiles["jobseeker"]
                                                  ["user"]["address"] !=
                                              null
                                          ? Text(
                                              _profileController
                                                      .profiles["jobseeker"]
                                                  ["user"]["address"],
                                              style: GoogleFonts.poppins(
                                                  fontSize: 22),
                                            )
                                          : Text("Null",
                                              style: GoogleFonts.poppins()),
                                    ],
                                  ),
                                ],
                              ),
                            ]),
                            Obx(() {
                              var filteredApplication = _privateclientController
                                  .privateApplications
                                  .where((application) =>
                                      application["status"] == "Accepted");
                              return Container(
                                margin: EdgeInsets.only(top: 30),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                            _privateclientController
                                                .privatejobs.length
                                                .toString(),
                                            style: GoogleFonts.poppins(
                                                fontSize: 18)),
                                        Text("Jobs Posted",
                                            style: GoogleFonts.poppins(
                                                fontSize: 18))
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(1),
                                      height: 50,
                                      decoration:
                                          BoxDecoration(color: Colors.grey),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                            filteredApplication.length
                                                .toString(),
                                            style: GoogleFonts.poppins(
                                                fontSize: 18)),
                                        Text("Candidates hired",
                                            style: GoogleFonts.poppins(
                                                fontSize: 18))
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    );
                  }
                })));
  }
}
