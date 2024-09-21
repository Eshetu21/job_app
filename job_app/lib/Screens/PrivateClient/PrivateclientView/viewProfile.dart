// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Controllers/Profile/ProfileController.dart';

class ViewProfile extends StatefulWidget {
  final Map applicant;
  const ViewProfile({super.key, required this.applicant});

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  final ProfileController _profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    _profileController.fetchProfiles();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20)),
                    margin: EdgeInsets.only(right: 20, top: 20),
                    padding: EdgeInsets.all(16),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(widget.applicant["jobseeker"]["firstname"][0],
                              style: GoogleFonts.poppins(fontSize: 50)),
                          Text(widget.applicant["jobseeker"]["lastname"][0],
                              style: GoogleFonts.poppins(fontSize: 50)),
                        ])),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _profileController.isloading.value
                            ? Text("loading...")
                            : Text(
                                widget.applicant["jobseeker"]["firstname"] +
                                    " " +
                                    widget.applicant["jobseeker"]["lastname"],
                                style: GoogleFonts.poppins(fontSize: 20)),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 18),
                        widget.applicant["jobseeker"]["address"] != null
                            ? Text(
                                widget.applicant["jobseeker"]["address"],
                                style: GoogleFonts.poppins(),
                              )
                            : Text("Null", style: GoogleFonts.poppins()),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.email_outlined, size: 20),
                        widget.applicant["jobseeker"]["email"] != null
                            ? Text(
                                widget.applicant["jobseeker"]["email"],
                                style: GoogleFonts.poppins(),
                              )
                            : Text("Null", style: GoogleFonts.poppins()),
                      ],
                    ),
                  ],
                ),
              ]),
            ],
          ),
        ),
      ],
    );
  }
}
