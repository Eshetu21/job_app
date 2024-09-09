// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Controllers/JobSeeker/experience_controller.dart';
import 'package:job_app/Screens/JobSeeker/Jobseeker/jobseeker_profile.dart';
import 'package:job_app/Screens/JobSeeker/job_seeker_pic.dart';
import 'package:job_app/Widgets/JobSeeker/build_text_form.dart';

class JobSeekerExperience extends StatefulWidget {
  final bool isediting;
  final int? experienceId;
  final Map<String, dynamic>? experience;
  const JobSeekerExperience(
      {super.key, this.isediting = false, this.experienceId, this.experience});

  @override
  State<JobSeekerExperience> createState() => _JobSeekerExperienceState();
}

class _JobSeekerExperienceState extends State<JobSeekerExperience> {
  final ExperienceController _experienceController =
      Get.put(ExperienceController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void initState() {
    super.initState();
    if (widget.isediting && widget.experience != null) {
      _titleController.text = widget.experience?["exp_position_title"] ?? '';
      _companyController.text = widget.experience?["exp_company_name"] ?? '';
      _startController.text = widget.experience?["exp_start_date"] ?? '';
      _endController.text = widget.experience?["exp_end_date"] ?? '';
      _descriptionController.text = widget.experience?["exp_description"] ?? '';
      selectedJobType = widget.experience?["exp_job_type"];
    }
  }

  final box = GetStorage();
  String selectedJobType = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(right: 25, left: 25, bottom: 25, top: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Add work experience",
                  style: GoogleFonts.poppins(
                      color: Color(0xFF150B3D),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                    "Highlight your professional journey by detailing your work experience, including the positions you've held and the skills you've gained.",
                    style: GoogleFonts.poppins()),
                SizedBox(height: 20),
                buildTextFormField("Job Title", _titleController),
                SizedBox(height: 10),
                buildTextFormField("Company", _companyController),
                SizedBox(height: 10),
                DropdownButtonFormField(
                    decoration: InputDecoration(
                        label: Text("Job Type"),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey))),
                    items: [
                      DropdownMenuItem(
                          value: "Remote",
                          child: Text("Remote", style: GoogleFonts.poppins())),
                      DropdownMenuItem(
                          value: "Full-Time",
                          child:
                              Text("Full-Time", style: GoogleFonts.poppins())),
                      DropdownMenuItem(
                          value: "Part-Time",
                          child:
                              Text("Part-Time", style: GoogleFonts.poppins())),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedJobType = value!;
                      });
                    }),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: buildDateField("Start Date", _startController),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: buildDateField("End Date", _endController),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                buildTextFormField("Description", _descriptionController),
                SizedBox(height: 20),
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      int jobseeker = box.read("jobseekerId");
                      if (widget.isediting && widget.experienceId != null) {
                        await _experienceController.updateexperience(
                            jobseekerId: jobseeker,
                            experienceId: widget.experienceId,
                            title: _titleController.text.trim(),
                            company: _companyController.text.trim(),
                            type: selectedJobType,
                            start: _startController.text.trim(),
                            end: _endController.text.trim(),
                            description: _descriptionController.text.trim());
                      }
                     else {
                        await _experienceController.addexperience(
                            jobseekerid: jobseeker,
                            title: _titleController.text.trim(),
                            company: _companyController.text.trim(),
                            type: selectedJobType,
                            start: _startController.text.trim(),
                            end: _endController.text.trim(),
                            description: _descriptionController.text.trim());
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 40, bottom: 20),
                      width: 266,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xFF130160).withOpacity(0.7),
                      ),
                      child: Center(
                        child: Text("SAVE",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                    ),
                  ),
                ),
                if (widget.isediting ||
                    widget.isediting && widget.experienceId != null)
                  Obx(() {
                    if (_experienceController.updatedSucsessfully.value ==
                        true) {
                      Future.delayed(Duration.zero, () {
                        sucessfullyUpdated(context);
                      });
                    }
                    return SizedBox.shrink();
                  }),
                if (!widget.isediting)
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => JobSeekerPicture()));
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 80),
                        width: 266,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color(0xFF130160).withOpacity(0.7),
                        ),
                        child: Center(
                          child: Text("NOT NOW",
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
      ),
    );
  }

  void sucessfullyUpdated(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Success", style: GoogleFonts.poppins()),
              content: Text("Experience updated sucessfully",
                  style: GoogleFonts.poppins()),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: ((context) => JobseekerProfile())));
                      _experienceController.updatedSucsessfully.value = false;
                    },
                    child: Text(
                      "Ok",
                      style: GoogleFonts.poppins(),
                    ))
              ],
            ));
  }
}
