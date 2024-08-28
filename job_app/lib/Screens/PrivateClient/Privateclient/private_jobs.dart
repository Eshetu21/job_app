// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Controllers/PrivateClient/privateclient_controller.dart';

class PrivateJobs extends StatefulWidget {
  const PrivateJobs({super.key});

  @override
  State<PrivateJobs> createState() => _PrivateJobsState();
}

class _PrivateJobsState extends State<PrivateJobs> {
  final PrivateclientController _privateclientController =
      Get.put(PrivateclientController());
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          var jobs = _privateclientController.privatejobs[index];
          return Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(8.0),
                margin: EdgeInsets.symmetric(vertical: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      jobs["title"] ?? "Not Provided",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Type: ${jobs["type"] ?? "Not Provided"}",
                      style: GoogleFonts.poppins(),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Sector: ${jobs["sector"] ?? "Not Provided"}",
                      style: GoogleFonts.poppins(),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "City: ${jobs["city"] ?? "Not Provided"}",
                      style: GoogleFonts.poppins(),
                    ),
                    SizedBox(height: 4),
                    Text("Gender: ${jobs["gender"] ?? "Not Provided"}",
                        style: GoogleFonts.poppins()),
                    SizedBox(height: 4),
                    Text("Salary: ${jobs["salary"] ?? "Not Provided"}",
                        style: GoogleFonts.poppins()),
                    SizedBox(height: 4),
                    Text("Deadline: ${jobs["deadline"] ?? "Not Provided"}",
                        style: GoogleFonts.poppins()),
                    SizedBox(height: 4),
                    Text(
                      "Description: ${jobs["description"] ?? "Not Provided"}",
                      style: GoogleFonts.poppins(),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        separatorBuilder: (_, index) {
          return SizedBox(height: 3);
        },
        itemCount: _privateclientController.privatejobs.length);
  }
}
