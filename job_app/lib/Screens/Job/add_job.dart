// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Controllers/Job/JobController.dart';
import 'package:job_app/Widgets/JobSeeker/build_text_form.dart';

class AddJob extends StatefulWidget {
  const AddJob({super.key});

  @override
  State<AddJob> createState() => _AddJobState();
}

class _AddJobState extends State<AddJob> {
  final Jobcontroller _jobcontroller = Get.put(Jobcontroller());
  final TextEditingController _title = TextEditingController();
  final TextEditingController _type = TextEditingController();
  final TextEditingController _sector = TextEditingController();
  final TextEditingController _gender = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final TextEditingController _salary = TextEditingController();
  final TextEditingController _deadline = TextEditingController();
  final TextEditingController _description = TextEditingController();
  List sector = [];
  List city = [];
  List gender = [];
  List type = [];
  @override
  void initState() {
    super.initState();
    loadDatas();
  }

  Future<void> loadDatas() async {
    final sectors = await rootBundle.loadString("assets/json/jobsector.json");
    var sec = json.decode(sectors);
    final cities = await rootBundle.loadString("assets/json/cities.json");
    var ci = json.decode(cities);
    final gen = await rootBundle.loadString("assets/json/gender.json");
    var gende = json.decode(gen);

    setState(() {
      sector = sec['sectors'];
      type = sec['type'];
      city = ci['cities'];
      gender = gende["gender"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              margin: EdgeInsets.only(right: 25, left: 25, bottom: 25, top: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "New Job Post",
                    style: GoogleFonts.poppins(
                        color: Color(0xFF150B3D),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  buildTextFormField("Job title", _title),
                  SizedBox(height: 8),
                  DropdownButtonFormField(
                      decoration: InputDecoration(
                          labelText: "Job Type", border: OutlineInputBorder()),
                      items: type
                          .map((type) => DropdownMenuItem(
                            value: type,
                              child: Text(type, style: GoogleFonts.poppins())))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _type.text = value.toString();
                        });
                      }),
                  SizedBox(height: 8),
                  DropdownButtonFormField(
                      decoration: InputDecoration(
                          labelText: "Sector", border: OutlineInputBorder()),
                      items: sector
                          .map((sector) => DropdownMenuItem(
                              value: sector,
                              child:
                                  Text(sector, style: GoogleFonts.poppins())))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _sector.text = value.toString();
                        });
                      }),
                  SizedBox(height: 8),
                  DropdownButtonFormField(
                      decoration: InputDecoration(
                          labelText: "City", border: OutlineInputBorder()),
                      items: city
                          .map((city) => DropdownMenuItem(
                              value: city,
                              child: Text(city, style: GoogleFonts.poppins())))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _city.text = value.toString();
                        });
                      }),
                  SizedBox(height: 8),
                  DropdownButtonFormField(
                      decoration: InputDecoration(
                          labelText: "Gender", border: OutlineInputBorder()),
                      items: gender
                          .map((gender) => DropdownMenuItem(
                              value: gender,
                              child:
                                  Text(gender, style: GoogleFonts.poppins())))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _gender.text = value.toString();
                        });
                      }),
                  SizedBox(height: 8),
                  buildTextFormField("Salary", _salary),
                  SizedBox(height: 8),
                  buildDateField("Deadline", _deadline),
                  SizedBox(height: 8),
                  buildTextFormField("Description", _description),
                  SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        await _jobcontroller.createjob(
                            title: _title.text.trim(),
                            city: _city.text.trim(),
                            type: _type.text.trim(),
                            sector: _sector.text.trim(),
                            gender: _gender.text.trim(),
                            deadline: _deadline.text.trim(),
                            description: _description.text.trim());
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 30, bottom: 20),
                        width: 266,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color(0xFF130160).withOpacity(0.7),
                        ),
                        child: Center(
                          child: Text("POST",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      ),
                    ),

                  ),
              Obx((){
                if(_jobcontroller.sucess.value==true){
                  Future.delayed(Duration.zero,(){
                   sucessfullyUpdated(context);
                  });
                }
                return SizedBox.shrink();
              }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void sucessfullyUpdated(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Success", style: GoogleFonts.poppins()),
              content: Text("Job added sucessfully",
                  style: GoogleFonts.poppins()),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);  
                      Navigator.pop(context); 
                      _jobcontroller.sucess.value=false; 
                    },
                    child: Text(
                      "Ok",
                      style: GoogleFonts.poppins(),
                    ))
              ],
            ));
  }
}
