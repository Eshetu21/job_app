// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Controllers/Company/company_controller.dart';
import 'package:job_app/Screens/Profiles/profiles.dart';
import 'package:job_app/Widgets/JobSeeker/build_text_form.dart';

class AddCompany extends StatefulWidget {
  const AddCompany({super.key});

  @override
  State<AddCompany> createState() => _AddCompanyState();
}

class _AddCompanyState extends State<AddCompany> {
  final CompanyController _companyController = Get.put(CompanyController());
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String logo = '';
  Future<void> pickCompanyLogo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        logo = result.files.single.path ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back_outlined)),
                    Text("Add Company",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF130160)))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    "Add your company details below. Please make sure to fill in all the required fields to create your company profile",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500, color: Color(0xFF130160)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 18),
                  child: Form(
                      key: _formKey,
                      child: TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                            labelText: "Company logo",
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  pickCompanyLogo();
                                },
                                icon: Icon(Icons.file_upload))),
                        controller: TextEditingController(text: logo),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Company logo is required";
                          }
                          return null;
                        },
                      )),
                ),
                SizedBox(height: 8),
                buildTextFormField("Company name", _name),
                SizedBox(height: 8),
                buildTextFormField("Telephone", _phone),
                SizedBox(height: 8),
                buildTextFormField("Address", _address),
                SizedBox(height: 8),
                buildTextFormField("Description", _description),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      _companyController.createCompany(
                          name: _name.text.trim(),
                          logo: File(logo),
                          phone: _phone.text.trim(),
                          address: _address.text.trim(),
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
                        child: Text("Add Company",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                    ),
                  ),
                ),
                Obx(() {
                  if (_companyController.sucessfullyAdded.value == true) {
                    Future.delayed(Duration.zero, () {
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
    );
  }

  void sucessfullyUpdated(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Success", style: GoogleFonts.poppins()),
              content: Text("Company added sucessfully",
                  style: GoogleFonts.poppins()),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Get.offAll(Profiles());
                      _companyController.sucessfullyAdded.value = false;
                    },
                    child: Text(
                      "Ok",
                      style: GoogleFonts.poppins(),
                    ))
              ],
            ));
  }
}
