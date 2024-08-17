// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, avoid_unnecessary_containers, sized_box_for_whitespace, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Controllers/JobSeeker/jobseeker_controller.dart';
import 'package:job_app/Controllers/Profile/ProfileController.dart';
import 'package:job_app/Screens/JobSeeker/Jobseeker/applications_page.dart';
import 'package:job_app/Screens/JobSeeker/Jobseeker/explore_page.dart';
import 'package:job_app/Screens/JobSeeker/Jobseeker/jobseeker_profile.dart';
import 'package:job_app/Screens/Profiles/profiles.dart';

class JobSeekerHomepage extends StatefulWidget {
  const JobSeekerHomepage({super.key});

  @override
  State<JobSeekerHomepage> createState() => _JobSeekerHomepageState();
}

class _JobSeekerHomepageState extends State<JobSeekerHomepage> {
  final JobSeekerController _jobSeekerController =
      Get.put(JobSeekerController());
  final ProfileController _profileController = Get.put(ProfileController());
  String selectedProfile = '';
  int currentindex = 0;
  final PageController _pageController = PageController();
  @override
  void initState() {
    super.initState();
    _jobSeekerController.getJobSeeker();
    _jobSeekerController.fetchJobSeeker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.only(top: 20, right: 20, left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text("Welcome",
                        style: GoogleFonts.poppins(
                            fontSize: 24, color: Color(0xFFFF9228))),
                    Spacer(),
                    Icon(Icons.settings_rounded),
                    SizedBox(width: 10),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.white.withOpacity(0.7),
                              builder: (context) {
                                return StatefulBuilder(
                                  builder: (BuildContext context,
                                      StateSetter setState) {
                                    return Container(
                                      width: double.infinity,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.4,
                                      child: Column(
                                        children: [
                                          if (_profileController
                                              .isloading.value)
                                            Center(
                                                child:
                                                    CircularProgressIndicator())
                                          else ...[
                                            if (_profileController.profiles[
                                                        "privateclient"] ==
                                                    null &&
                                                _profileController
                                                        .profiles["company"] ==
                                                    null)
                                              Padding(
                                                padding: EdgeInsets.all(20),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "No other accounts created tap to add",
                                                      style:
                                                          GoogleFonts.poppins(),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        Profiles()));
                                                      },
                                                      child: Container(
                                                        margin:
                                                            EdgeInsets.all(20),
                                                        child: Center(
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        80,
                                                                    vertical:
                                                                        10),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.2)),
                                                            child: Text(
                                                                "Add Account",
                                                                style: GoogleFonts.poppins(
                                                                    color: Color(
                                                                        0xFF130160),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500)),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            if (_profileController.profiles[
                                                    "privateclient"] !=
                                                null)
                                              _profileContainer(
                                                ListTile(
                                                  leading: Image.asset(
                                                    "assets/icons/private.png",
                                                    width: 28,
                                                    color: Color(0xFFFF9228)
                                                        .withOpacity(0.4),
                                                  ),
                                                  title: Text(
                                                    _profileController.profiles[
                                                                    'privateclient']
                                                                ['user']
                                                            ['firstname'] +
                                                        " " +
                                                        _profileController
                                                                    .profiles[
                                                                'jobseeker'][
                                                            'user']['lastname'],
                                                  ),
                                                  subtitle:
                                                      Text("Private Client"),
                                                  trailing: Radio(
                                                    value: 'privateclient',
                                                    groupValue: selectedProfile,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        selectedProfile =
                                                            value.toString();
                                                      });
                                                    },
                                                  ),
                                                ),
                                                "private",
                                              ),
                                            if (_profileController
                                                    .profiles["company"] !=
                                                null)
                                              _profileContainer(
                                                ListTile(
                                                  leading: Image.asset(
                                                    "assets/icons/company.png",
                                                    width: 28,
                                                    color: Color(0xFFFF9228)
                                                        .withOpacity(0.4),
                                                  ),
                                                  title: Text("company"),
                                                  subtitle: Text("Company"),
                                                  trailing: Radio(
                                                    value: 'company',
                                                    groupValue: selectedProfile,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        selectedProfile =
                                                            value.toString();
                                                      });
                                                    },
                                                  ),
                                                ),
                                                "company",
                                              ),
                                          ],
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                          child: Image.asset("assets/icons/switch.png")),
                    )
                  ],
                ),
                Obx(() {
                  if (_jobSeekerController.jobseeker.isEmpty) {
                    return FutureBuilder(
                        future: _jobSeekerController.getJobSeeker(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text("Error ${snapshot.error}");
                          } else if (snapshot.hasData) {
                            var jobseekerData =
                                snapshot.data as Map<String, dynamic>;
                            _jobSeekerController.jobseeker.value =
                                jobseekerData;
                            String firstname =
                                jobseekerData["jobseeker"]["user"]["firstname"];
                            return Text(
                              firstname,
                            );
                          } else {
                            return Text("No data found");
                          }
                        });
                  } else {
                    var jobSeekerData = _jobSeekerController.jobseeker;
                    String firstname =
                        jobSeekerData["jobseeker"]["user"]["firstname"];
                    return Text(firstname,
                        style: GoogleFonts.poppins(fontSize: 20));
                  }
                }),
                SizedBox(height: 15),
                TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none),
                      hintText: "Search for jobs...",
                      hintStyle: GoogleFonts.poppins(),
                      prefixIcon: Icon(Icons.search_outlined),
                      fillColor: Colors.white.withOpacity(0.7),
                      filled: true),
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        currentindex = index;
                      });
                    },
                    children: [
                      ExplorePage(),
                      ApplicationPage(),
                    ],
                  ),
                ),
                BottomNavigationBar(
                  currentIndex: currentindex,
                  onTap: (index) {
                    if (index == 2) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => JobseekerProfile()));
                    } else {
                      setState(() {
                        currentindex = index;
                        _pageController.jumpToPage(index);
                      });
                    }
                  },
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.explore),
                      label: 'Explore',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.description),
                      label: 'Applications',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      label: 'Profile',
                    ),
                  ],
                  selectedItemColor: Colors.orange,
                  unselectedItemColor: Colors.black,
                  showUnselectedLabels: true,
                  elevation: 0,
                  selectedLabelStyle:
                      GoogleFonts.poppins(fontWeight: FontWeight.w400),
                )
              ],
            ),
          ),
        ));
  }

  Widget _profileContainer(Widget child, String value) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedProfile = value;
        });
      },
      child: Container(
        margin: EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: Offset(0, 2))
            ]),
        child: child,
      ),
    );
  }
}
