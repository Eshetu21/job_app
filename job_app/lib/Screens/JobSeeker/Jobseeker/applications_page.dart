// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Controllers/JobSeeker/application_controller.dart';

class ApplicationPage extends StatefulWidget {
  const ApplicationPage({super.key});

  @override
  State<ApplicationPage> createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> {
  final ApplicationController _applicationController =
      Get.put(ApplicationController());

  @override
  Widget build(BuildContext context) {
    _applicationController.getApplication();
    return FutureBuilder(
        future: _applicationController.getApplication(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (_applicationController.myApplications.isEmpty) {
            return Center(
                child: Text("No applications found",
                    style: GoogleFonts.poppins()));
          } else {
            return Container(
              color: Colors.transparent,
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    var applications =
                        _applicationController.myApplications[index];
                    return Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  applications["job"]["title"] ??
                                      "Not Provided",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.pending,
                                        color: Colors.orange, size: 15),
                                    SizedBox(width: 5),
                                    Text(applications["status"],
                                        style: GoogleFonts.poppins()),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(Icons.business_center, size: 16),
                                SizedBox(width: 5),
                                Text(
                                  applications["job"]["sector"] ??
                                      "Not Provided",
                                  style: GoogleFonts.poppins(),
                                ),
                              ],
                            ),
                            SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(Icons.location_on, size: 16),
                                SizedBox(width: 5),
                                Text(
                                  applications["job"]["city"] ?? "Not Provided",
                                  style: GoogleFonts.poppins(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (_, index) {
                    return SizedBox(height: 10);
                  },
                  itemCount: _applicationController.myApplications.length),
            );
          }
        });
  }
}
