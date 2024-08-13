// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Controllers/JobSeeker/education_controller.dart';
import 'package:job_app/Screens/JobSeeker/job_seeker_experience.dart';
import 'package:job_app/Widgets/dateformat.dart';

class JobSeekerCreateSecond extends StatefulWidget {
  const JobSeekerCreateSecond({super.key});

  @override
  State<JobSeekerCreateSecond> createState() => _JobSeekerCreateSecondState();
}

class _JobSeekerCreateSecondState extends State<JobSeekerCreateSecond> {
  final EducationController _educationController =
      Get.put(EducationController());
  final TextEditingController _institutionController = TextEditingController();
  final TextEditingController _levelofeducation = TextEditingController();
  final TextEditingController _field = TextEditingController();
  final TextEditingController _startDate = TextEditingController();
  final TextEditingController _edndate = TextEditingController();
  final TextEditingController _description = TextEditingController();
  var educationDetails = {};
  final box = GetStorage();
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.only(right: 25, left: 25, bottom: 25, top: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Add Education",
                  style: GoogleFonts.poppins(
                      color: Color(0xFF150B3D),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                _buildTextField("Institution name", _institutionController),
                SizedBox(height: 10),
                _buildTextField("Level of education", _levelofeducation),
                SizedBox(height: 10),
                _buildTextField("Field of study", _field),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _buildDateField("Start Date", _startDate),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: _buildDateField("End Date", _edndate),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                _buildTextField("Description", _description),
                SizedBox(height: 40),
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      int jobseeker = box.read("jobseekerId");
                      print(jobseeker);
                      print(_institutionController.text);
                      print(_startDate.text);
                      await _educationController.createeducation(
                          jobseekerid: jobseeker,
                          institution: _institutionController.text.trim(),
                          field: _field.text.trim(),
                          eduLevel: _levelofeducation.text.trim(),
                          eduStart: _startDate.text.trim(),
                          eduEnd: _edndate.text.trim(),
                          eduDescription: _description.text.trim());
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20),
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
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>JobSeekerExperience()));
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

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Color(0xFF150B3D),
            fontSize: 14,
          ),
        ),
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white.withOpacity(0.5)),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(10),
                hintText: "",
                hintStyle:
                    TextStyle(fontFamily: GoogleFonts.poppins().fontFamily)),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Color(0xFF150B3D),
            fontSize: 14,
          ),
        ),
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withOpacity(0.5),
          ),
          child: TextField(
            controller: controller,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
              DateTextInputFormatter(),
            ],
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(10),
              hintText: "DD/MM/YY",
              hintStyle: TextStyle(
                fontFamily: GoogleFonts.poppins().fontFamily,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
