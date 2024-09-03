// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Controllers/PrivateClient/privateclient_controller.dart';
import 'package:job_app/Controllers/User/UserController.dart';
import 'package:job_app/Controllers/Profile/ProfileController.dart';
import 'package:job_app/Screens/JobSeeker/job_seeker_homepage.dart';
import 'package:job_app/Screens/PrivateClient/private_client_homepage.dart';

class Profiles extends StatefulWidget {
  const Profiles({super.key});

  @override
  State<Profiles> createState() => _ProfilesState();
}

class _ProfilesState extends State<Profiles> {
  final ProfileController _profileController = Get.put(ProfileController());
  final UserAuthenticationController _userAuthenticationController =
      Get.put(UserAuthenticationController());
  final PrivateclientController _privateclientController =
      Get.put(PrivateclientController());
  String selectedProfile = '';
  bool showAddAcount = false;

  @override
  Widget build(BuildContext context) {
    print(_profileController.profiles);
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Obx(() {
          return Center(
              child: _profileController.isloading.value
                  ? CircularProgressIndicator()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("My Accounts",
                                  style: GoogleFonts.poppins(
                                      color: Color(0xFF0D0140),
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600)),
                              GestureDetector(
                                onTap: () {
                                  _userAuthenticationController.logout();
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.logout_outlined,
                                      color: Color(0xFF130160),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text("LOG OUT",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF130160))),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_profileController.profiles['jobseeker'] != null)
                          _profileContainer(
                              ListTile(
                                leading: Image.asset(
                                    "assets/icons/job_seeker.png",
                                    width: 23,
                                    color: Color(0xFFFF9228).withOpacity(0.4)),
                                title: Text(
                                    _profileController.profiles['jobseeker']
                                            ['user']['firstname'] +
                                        " " +
                                        _profileController.profiles['jobseeker']
                                            ['user']['lastname']),
                                subtitle: Text("Job Seeker"),
                                trailing: Radio(
                                    value: 'jobseeker',
                                    groupValue: selectedProfile,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedProfile = value.toString();
                                      });
                                    }),
                              ),
                              "jobseeker"),
                        if (_profileController.profiles['privateclient'] !=
                            null)
                          _profileContainer(
                              ListTile(
                                leading: Image.asset("assets/icons/private.png",
                                    width: 28,
                                    color: Color(0xFFFF9228).withOpacity(0.4)),
                                title: Text(_profileController
                                            .profiles['privateclient']['user']
                                        ['firstname'] +
                                    " " +
                                    _profileController.profiles['privateclient']
                                        ['user']['lastname']),
                                subtitle: Text("Private Client"),
                                trailing: Radio(
                                    value: 'privateclient',
                                    groupValue: selectedProfile,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedProfile = value.toString();
                                      });
                                    }),
                              ),
                              "privateclient"),
                        if (_profileController.profiles['company'] != null)
                          _profileContainer(
                              ListTile(
                                leading: Image.asset("assets/icons/company.png",
                                    width: 28,
                                    color: Color(0xFFFF9228).withOpacity(0.4)),
                                title: Text("company"),
                                subtitle: Text("Company"),
                                trailing: Radio(
                                    value: 'company',
                                    groupValue: selectedProfile,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedProfile = value.toString();
                                      });
                                    }),
                              ),
                              "company"),
                        if (showAddAcount)
                          Column(
                            children: [
                              if (_profileController.profiles['jobseeker'] ==
                                  null)
                                _profileContainer(
                                    ListTile(
                                      leading: Image.asset(
                                          "assets/icons/job_seeker.png",
                                          width: 23,
                                          color: Color(0xFFFF9228)
                                              .withOpacity(0.4)),
                                      title: Text("Job Seeker"),
                                      subtitle: Text("Add account"),
                                      trailing: Radio(
                                          value: 'jobseeker',
                                          groupValue: selectedProfile,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedProfile =
                                                  value.toString();
                                            });
                                          }),
                                    ),
                                    "jobseeker"),
                              if (_profileController
                                      .profiles['privateclient'] ==
                                  null)
                                _profileContainer(
                                    ListTile(
                                      leading: Image.asset(
                                          "assets/icons/private.png",
                                          width: 28,
                                          color: Color(0xFFFF9228)
                                              .withOpacity(0.4)),
                                      title: Text("Private Client"),
                                      subtitle: Text("Add account"),
                                      trailing: Radio(
                                          value: 'private',
                                          groupValue: selectedProfile,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedProfile =
                                                  value.toString();
                                            });
                                          }),
                                    ),
                                    "privateclient"),
                              if (_profileController.profiles['company'] ==
                                  null)
                                _profileContainer(
                                    ListTile(
                                      leading: Image.asset(
                                          "assets/icons/company.png",
                                          width: 28,
                                          color: Color(0xFFFF9228)
                                              .withOpacity(0.4)),
                                      title: Text("Company"),
                                      subtitle: Text("Add account"),
                                      trailing: Radio(
                                          value: 'company',
                                          groupValue: selectedProfile,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedProfile =
                                                  value.toString();
                                            });
                                          }),
                                    ),
                                    "company"),
                            ],
                          ),
                        if (_profileController.profiles['jobseeker'] == null ||
                            _profileController.profiles['privateclient'] ==
                                null ||
                            _profileController.profiles['company'] == null)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                showAddAcount = !showAddAcount;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.all(20),
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 80, vertical: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.grey.withOpacity(0.2)),
                                  child: Text(
                                      showAddAcount
                                          ? "My Accounts"
                                          : "Add Account",
                                      style: GoogleFonts.poppins(
                                          color: Color(0xFF130160),
                                          fontWeight: FontWeight.w500)),
                                ),
                              ),
                            ),
                          ),
                        Spacer(),
                        GestureDetector(
                          onTap: () async {
                            if (selectedProfile == 'jobseeker') {
                              Get.off(JobSeekerHomepage());
                            }
                            if (selectedProfile == "private") {
                              print(_profileController.profiles["privateclient"]);
                              if (_profileController
                                      .profiles['privateclient'] ==
                                  null) {
                                bool success = await _privateclientController
                                    .createprivateclient();
                                if (success) {
                                  Get.off(PrivateClientHomepage());
                                } else {
                                  print("failed to create privaeclient");
                                }
                              } else {
                                Get.off(PrivateClientHomepage());
                              }
                            }
                          },
                          child: Center(
                            child: Container(
                              margin: EdgeInsets.only(bottom: 40),
                              width: 266,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color(0xFF130160).withOpacity(0.7),
                              ),
                              child: Center(
                                child: Text("Continue",
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ),
                            ),
                          ),
                        )
                      ],
                    ));
        }),
      )),
    );
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
