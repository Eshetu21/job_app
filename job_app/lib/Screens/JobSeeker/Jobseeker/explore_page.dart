// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Controllers/Job/JobController.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

var tabList = ["All Jobs", "Saved Jobs"];

class _ExplorePageState extends State<ExplorePage> {
  final Jobcontroller _jobcontroller = Get.put(Jobcontroller());
  @override
  void initState() {
    super.initState();
    _jobcontroller.getJobs();
  }
  @override
  Widget build(BuildContext context) {
    print(_jobcontroller.alljobs);
    return Container(
        color: Colors.transparent,
        child: ListView.separated(
            itemBuilder: (context,index){
              var jobs = _jobcontroller.alljobs[index];
               return Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20)),
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.all(8.0),
                          margin: EdgeInsets.symmetric(vertical: 5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    jobs["title"] ?? "Not Provided",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Spacer(),
                                  Icon(Icons.timer,color: Colors.red,size: 20),
                                  Text(
                                      "${jobs["deadline"] ?? "Not Provided"}",
                                      style: GoogleFonts.poppins()),
                                ],
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
                              Text(
                                  "Gender: ${jobs["gender"] ?? "Not Provided"}",
                                  style: GoogleFonts.poppins()),
                              SizedBox(height: 4),
                              Text(
                                  "Salary: ${jobs["salary"] ?? "Not Provided"}",
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
            separatorBuilder: (_,index)=>SizedBox(height: 10),
            itemCount: _jobcontroller.alljobs.length));
  }
}
