// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Controllers/Company/company_controller.dart';

class CompanyJobs extends StatefulWidget {
  const CompanyJobs({super.key});

  @override
  State<CompanyJobs> createState() => _CompanyJobsState();
}

class _CompanyJobsState extends State<CompanyJobs> {
  final CompanyController _companyController = Get.put(CompanyController());
  @override
  void initState() {
    super.initState();
    _companyController.fetchCompanyJob();
  }
  @override
  Widget build(BuildContext context) {
    return  FutureBuilder(
        future:_companyController.fetchCompanyJob(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (_companyController.companyJobs.isEmpty) {
            return Center(
                child: Text("No jobs posted", style: GoogleFonts.poppins()));
          } else {
            return Obx(() {
              return ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var jobs = _companyController.companyJobs[index];
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
                  separatorBuilder: (_, index) {
                    return SizedBox(height: 3);
                  },
                  itemCount: _companyController.companyJobs.length);
            });
          }
        });
  }
}