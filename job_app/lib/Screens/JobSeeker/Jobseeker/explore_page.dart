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
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _jobcontroller.getJobs();
    _companyController.fetchCompany();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for jobs...',
                hintStyle: GoogleFonts.poppins(),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(20),
                ),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: _jobcontroller.getJobs(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                      strokeWidth: 2,
                      strokeAlign: -5,
                    ));
                  }
                  if (_jobcontroller.alljobs.isEmpty) {
                    return Center(
                        child: Text("No jobs available",
                            style: GoogleFonts.poppins()));
                  } else {
                    var filteredJobs = _jobcontroller.alljobs.where((job) {
                      return (job["title"] ?? "")
                              .toLowerCase()
                              .contains(searchQuery) ||
                          (job["sector"] ?? "")
                              .toLowerCase()
                              .contains(searchQuery) ||
                          (job["type"] ?? "")
                              .toLowerCase()
                              .contains(searchQuery) ||
                          (job["description"] ?? "")
                              .toLowerCase()
                              .contains(searchQuery) ||
                          (job["salary"] ?? "")
                              .toString()
                              .toLowerCase()
                              .contains(searchQuery) ||
                          (job["city"] ?? "")
                              .toLowerCase()
                              .contains(searchQuery);
                    }).toList();

                    if (filteredJobs.isEmpty) {
                      return Center(
                        child: Text("No matching jobs found",
                            style: GoogleFonts.poppins()),
                      );
                    }

                    return Container(
                        color: Colors.transparent,
                        child: ListView.separated(
                          itemBuilder: (context, index) {
                            var jobs = filteredJobs[index];
                            var poster = jobs["company_id"] != null
                                ? "Company Job"
                                : "Private Client Job";
                            var companyName =
                                _companyController.company["company_name"];
                            var companyLogo =
                                _companyController.company["company_logo"];
                            var id = jobs["id"];

                            return GestureDetector(
                              onTap: () {
                                _showApplyModal(
                                    context,
                                    id,
                                    poster,
                                    jobs["title"],
                                    jobs["type"],
                                    jobs["salary"] ?? "Negotiable",
                                    jobs["city"],
                                    jobs["description"] ?? "No Description",
                                    companyLogo,
                                    companyName);
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            jobs["title"] ?? "Not Provided",
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Icon(Icons.timer,
                                                  color: Colors.red, size: 15),
                                              SizedBox(width: 5),
                                              Text(
                                                  "${jobs["deadline"] ?? "Not Provided"}",
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
                                            "${jobs["sector"] ?? "Not Provided"}",
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
                                            "${jobs["city"] ?? "Not Provided"}",
                                            style: GoogleFonts.poppins(),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Icon(Icons.person, size: 16),
                                          SizedBox(width: 5),
                                          Text(
                                            "${jobs["gender"] ?? "Not Provided"}",
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
                          separatorBuilder: (_, index) => SizedBox(height: 10),
                          itemCount: filteredJobs.length,
                        ));
                  }
                }),
          ),
        ],
      ),
    );
  }

  void _showApplyModal(
      BuildContext context,
      int jobId,
      String poster,
      String title,
      String type,
      String salary,
      String city,
      String description,
      String? companyLogo,
      String? companyName) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        builder: (context) {
          return DraggableScrollableSheet(
            expand: false,
            maxChildSize: 0.9,
            builder: (_, controller) {
              return SingleChildScrollView(
                controller: controller,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(poster,
                            style: GoogleFonts.poppins(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        if (poster == "Company Job")
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
                              SizedBox(width: 10),
                              if (companyName != null)
                                Text(companyName,
                                    style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500)),
                            ],
                          ),
                        SizedBox(height: 5),
                        Text(title,
                            style: GoogleFonts.poppins(
                                fontSize: 20, fontWeight: FontWeight.w500)),
                        SizedBox(height: 5),
                        Text(type,
                            style: GoogleFonts.poppins(
                                color: Colors.grey, fontSize: 16)),
                        SizedBox(height: 5),
                        Text(city,
                            style: GoogleFonts.poppins(
                                color: Colors.black, fontSize: 16)),
                        SizedBox(height: 5),
                        Text(salary,
                            style: GoogleFonts.poppins(
                                color: Colors.green, fontSize: 16)),
                        SizedBox(height: 5),
                        Text(description,
                            style: GoogleFonts.poppins(
                                fontSize: 16, color: Colors.black87)),
                        SizedBox(height: 10),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      JobSeekerApply(jobId: jobId)));
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
                  ),
                ),
              );
            },
          );
        });
  }
}
