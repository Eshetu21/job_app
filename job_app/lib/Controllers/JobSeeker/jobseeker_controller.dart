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
  late int? jobseekerId;
  @override
  void onInit() {
    super.onInit();
    getJobSeeker();
  }

  JobSeekerController() {
    token = box.read("token");
  }

  Future<void> createjobseeker() async {
    final response = await http.post(
      Uri.parse("${url}js/create"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    if (response.statusCode == 201) {
      print("sucessfully created jobseeker profileeeeeeeeeeeee");
    } else {
      print(response.statusCode);
      print(response.body);
      print("failed to created");
    }
  }

  Future<Map<String, dynamic>> getJobSeeker() async {
    final response = await http.get(
      Uri.parse("${url}js/get"),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      jobseekerId = responseData["jobseeker"]["id"];
      box.write("jobseekerId", jobseekerId);
      return responseData;
    } else {
      return {"error": "Failed to retrieve job seeker data"};
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
      {required String category,
      required String subCategory,
      String? cv,
      String? aboutMe,
      String? profilePic,
      String? phoneNumber}) async {
    try {
      var data = {
        "category": category,
        "sub_category": subCategory,
        "profile_pic": profilePic ?? "",
        "cv": cv ?? "",
        "phone_number": phoneNumber ?? "",
        "about_me": aboutMe ?? ""
      };
      var encodedData = data.entries
          .map((e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
      final response = await http.put(Uri.parse("${url}js/update"),
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token",
            "Content-Type": "application/x-www-form-urlencoded",
          },
          body: encodedData);
      if (response.statusCode == 200) {
        print("Successfully updated jobseeker profile");
        print(encodedData);
      }
    } catch ($e) {
      print("Failed");
      print($e.toString());
    }
  }
}
