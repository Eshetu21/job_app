// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Controllers/Company/company_controller.dart';

class CompanyProfile extends StatefulWidget {
  const CompanyProfile({super.key});

  @override
  State<CompanyProfile> createState() => _CompanyProfileState();
}

class _CompanyProfileState extends State<CompanyProfile> {
  final CompanyController _companyController = Get.put(CompanyController());
  @override
  void initState() {
    super.initState();
    _companyController.fetchCompany();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: FutureBuilder(
                future: _companyController.fetchCompany(),
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
                  if (_companyController.company.isEmpty) {
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
                            Text("Company Profile",
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
                                            _companyController
                                                        .company["company_name"]
                                                    [0] +
                                                _companyController
                                                    .company["company_name"][1],
                                            style: GoogleFonts.poppins(
                                                fontSize: 50)),
                                      ])),
                              Column(
                                children: [
                                  Text(
                                      _companyController
                                          .company["company_name"],
                                      style: GoogleFonts.poppins(fontSize: 22)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.location_on_outlined,
                                          size: 18),
                                      Text(
                                        _companyController
                                            .company["company_address"],
                                        style:
                                            GoogleFonts.poppins(fontSize: 22),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.phone_android_outlined,
                                          size: 18),
                                      Text(
                                        _companyController
                                            .company["company_phone"],
                                        style:
                                            GoogleFonts.poppins(fontSize: 22),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ]),
                            Obx(() {
                              var filteredApplication = _companyController
                                  .companyApplications
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
                                            _companyController
                                                .companyJobs.length
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
