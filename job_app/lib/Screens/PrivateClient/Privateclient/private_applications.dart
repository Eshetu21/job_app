// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Controllers/PrivateClient/privateclient_controller.dart';
import 'package:job_app/Screens/PrivateClient/private_view_applicant.dart';
import 'package:timeago/timeago.dart' as timeago;

class PrivateApplications extends StatefulWidget {
  const PrivateApplications({super.key});

  @override
  State<PrivateApplications> createState() => _PrivateApplicationsState();
}

class _PrivateApplicationsState extends State<PrivateApplications> {
 String formatRelativeTime(String dateTimeString) {
  DateTime utcDateTime = DateTime.parse(dateTimeString);
  DateTime localDateTime = utcDateTime.toLocal(); 
  return timeago.format(localDateTime); 
}

  var selected = 0;
  List tabList = <String>["Pending", "Accepted", "Rejected"];

  final PrivateclientController _privateclientController =
      Get.put(PrivateclientController());

  @override
  Widget build(BuildContext context) {
    _privateclientController.getApplications();
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
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 22),
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
            future: _privateclientController.getApplications(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(
                  strokeWidth: 2,
                  strokeAlign: -6,
                ));
              } else if (_privateclientController.privateApplications.isEmpty) {
                return Center(
                    child: Text("No applications found",
                        style: GoogleFonts.poppins()));
              } else {
                List filteredApplication = [];
                if (selected == 0) {
                  filteredApplication =
                      _privateclientController.privateApplications;
                }
                if (selected == 1) {
                  filteredApplication = _privateclientController
                      .privateApplicationsJob
                      .where(
                          (application) => application["status"] == "Pending")
                      .toList();
                }
                if (selected == 2) {
                  filteredApplication = _privateclientController
                      .privateApplicationsJob
                      .where((application) =>
                          application["status"] == "Accepted" ||
                          application["status"] == "Rejected")
                      .toList();
                }
                if (filteredApplication.isEmpty) {
                  return Center(
                      child: Text("No applications found",
                          style: GoogleFonts.poppins()));
                }
                return Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top: 20),
                    height: MediaQuery.of(context).size.height * 0.6,
                    color: Colors.transparent,
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          var applications = filteredApplication[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PrivateViewApplicant(
                                              application: applications)));
                            },
                            child: Card(
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
                                          applications["jobseeker"]
                                                  ["firstname"] ??
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
                                            Text(
                                                formatRelativeTime(
                                                    applications["created_at"]),
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
                            ),
                          );
                        },
                        separatorBuilder: (_, index) {
                          return SizedBox(height: 10);
                        },
                        itemCount: _privateclientController
                            .privateApplications.length),
                  ),
                );
              }
            }),
      ],
    );
  }
}
