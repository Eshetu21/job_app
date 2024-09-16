// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Controllers/Company/company_controller.dart';
import 'package:job_app/Controllers/Job/JobController.dart';
import 'package:job_app/Screens/JobSeeker/job_seeker_apply.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final CompanyController _companyController = Get.put(CompanyController());
  final Jobcontroller _jobcontroller = Get.put(Jobcontroller());
  @override
  void initState() {
    super.initState();
    _jobcontroller.getJobs();
    _companyController.fetchCompany();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _jobcontroller.getJobs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (_jobcontroller.alljobs.isEmpty) {
            return Center(
                child: Text("No jobs available", style: GoogleFonts.poppins()));
          } else {
            return Obx(() {
              return Container(
                  color: Colors.transparent,
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        var jobs = _jobcontroller.alljobs[index];
                        var poster = jobs["company_id"] != null
                            ? "Company Job"
                            : "PrivateClient Job";
                        var companyName =
                            _companyController.company["company_name"];
                        var companyLogo =
                            _companyController.company["company_logo"];
                        var id = jobs["id"];
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _showApplyModal(
                                    context,
                                    id,
                                    poster,
                                    jobs["title"],
                                    jobs["type"],
                                    jobs["salary"] ?? "Negotiable",
                                    jobs["description"] ?? "Null",
                                    companyLogo,
                                    companyName);
                              },
                              child: Container(
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
                                        Icon(Icons.timer,
                                            color: Colors.red, size: 20),
                                        Text(
                                            "${jobs["deadline"] ?? "Not Provided"}",
                                            style: GoogleFonts.poppins()),
                                      ],
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
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (_, index) => SizedBox(height: 10),
                      itemCount: _jobcontroller.alljobs.length));
            });
          }
        });
  }

  void _showApplyModal(
      BuildContext context,
      int jobId,
      String poster,
      String title,
      String type,
      String salary,
      String description,
      String? companyLogo,
      String? companyName) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            margin: EdgeInsets.all(20),
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.45,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(poster,
                    style: GoogleFonts.poppins(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    companyLogo != null
                        ? ClipOval(
                            child: Image.network(
                            companyLogo,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ))
                        : Container(),
                    if (companyName != null) ...[Text(companyName)],
                  ],
                ),
                Text(title,
                    style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.w500)),
                Text(type),
                Text(salary),
                Text(description),
                Spacer(),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => JobSeekerApply()));
                    },
                    child: Container(
                      width: 266,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xFF130160),
                      ),
                      child: Center(
                        child: Text("Apply",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
