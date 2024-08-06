// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:job_app/constants/constants.dart';
import 'package:http/http.dart' as http;

class JobSeekerController extends GetxController {
  RxMap<String, dynamic> jobseeker = <String, dynamic>{}.obs;
  final box = GetStorage();
  late final String? token;
  @override
  void onInit() {
    super.onInit();
    createjobseeker();
    getJobSeeker();
  }

  JobSeekerController() {
    token = box.read("token");
  }

  Future<void> createjobseeker() async {
    final response = await http.post(
      Uri.parse("${url}createjobseeker"),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );
    if (response.statusCode == 201) {
      print("sucessfully created jobseeker profile");
    } else {
      print("failed to created");
    }
  }

  Future<Map<String, dynamic>> getJobSeeker() async {
    final response = await http.get(
      Uri.parse("${url}showjobseeker"),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      return responseData;
    } else {
      throw Exception("Failed to get jobseeker data");
    }
  }

  Future<void> fetchJobSeeker() async {
    try {
      var jobseekerData = await getJobSeeker();
      jobseeker.value = jobseekerData;
    } catch ($e) {
      print("Failed to fetch job seeker");
    }
  }

  Future updatejobseeker(
      {required int id,
      required String category,
      required String subCategory,
      String? cv,
      String? aboutMe,
      String? profilePic,
      String? phoneNumber}) async {
    try {
      var data = jsonEncode({
        "category": category,
        "sub_category": subCategory,
        "profile_pic": profilePic,
        "cv": cv,
        "phone_number": phoneNumber,
        "about_me": aboutMe
      });
      final response = await http.put(Uri.parse("${url}updatejobseeker/$id"),
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          },
          body: data);
      if (response.statusCode == 200) {
        print("Successfully updated jobseeker profile");
      }
    } catch ($e) {
      print("Failed");
      print($e.toString());
    }
  }
}
