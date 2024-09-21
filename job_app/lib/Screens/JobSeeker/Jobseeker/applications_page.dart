// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Controllers/JobSeeker/jobseeker_application_controller.dart';

class ApplicationPage extends StatefulWidget {
  const ApplicationPage({super.key});

  @override
  State<ApplicationPage> createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> {
  var selected = 0;
  List tabList = <String>["All", "Pending", "Reviewed"];
  final ApplicationController _applicationController =
      Get.put(ApplicationController());

  @override
  Widget build(BuildContext context) {
    _applicationController.getApplication();
    return Column(
      children: [
        Container(
          height: 40,
          child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selected = index;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: selected == index
                                ? Color(0xFF43B1B7)
                                : Color(0xFF43B1B7).withOpacity(0.2)),
                        color: selected == index
                            ? Color(0xFF43B1B7).withOpacity(0.8)
                            : Colors.white),
                    child: Text(tabList[index],
                        style: GoogleFonts.poppins(
                            color: selected == index
                                ? Colors.white
                                : Colors.black)),
                  ),
                );
              },
              separatorBuilder: (_, index) {
                return SizedBox(width: 10);
              },
              itemCount: tabList.length),
        ),
        FutureBuilder(
            future: _applicationController.getApplication(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(
                  strokeWidth: 2,
                  strokeAlign: -6,
                ));
              } else {
                List filteredApplication = [];
                if (selected == 0) {
                  filteredApplication = _applicationController.myApplications;
                }
                if (selected == 1) {
                  filteredApplication = _applicationController.myApplications
                      .where(
                          (application) => application["status"] == "Pending")
                      .toList();
                }
                if (selected == 2) {
                  filteredApplication = _applicationController.myApplications
                      .where((application) =>
                          application["status"] == "Accepted" ||
                          application["status"] == "Rejected")
                      .toList();
                }
                if (selected == 0 && filteredApplication.isEmpty) {
                  return Center(
                      child: Text("No applications found",
                          style: GoogleFonts.poppins()));
                }
                if (selected == 1 && filteredApplication.isEmpty) {
                  return Center(
                      child: Text("No pending applications found",
                          style: GoogleFonts.poppins()));
                }
                if (selected == 2 && filteredApplication.isEmpty) {
                  return Center(
                      child: Text("No reviewed applications found",
                          style: GoogleFonts.poppins()));
                }
                return Container(
                  padding: EdgeInsets.only(top: 20),
                  height: MediaQuery.of(context).size.height * 0.7,
                  color: Colors.transparent,
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        var applications = filteredApplication[index];

                        return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                      applications["job"]["city"] ??
                                          "Not Provided",
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
            }),
      ],
    );
  }
}
