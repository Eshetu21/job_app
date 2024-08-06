import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:job_app/constants/constants.dart';
import 'package:http/http.dart' as http;

class GetJobSeeker {
  Future<Map<String, dynamic>> getJobSeeker() async {
    final box = GetStorage();
    final token = box.read("token");

    final response = await http.get(
      Uri.parse("${url}showjobseeker"),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      return responseData["jobseeker"];
    } else {
      throw Exception("Failed to get jobseeker data");
    }
  }
}

class JobSeekerController extends GetxController {
  RxMap<String, dynamic> jobseeker = <String, dynamic>{}.obs;
  final GetJobSeeker _getJobSeeker = Get.put(GetJobSeeker());

  @override
  void onInit() {
    super.onInit();
    fetchJobSeeker();
  }

  Future<void> fetchJobSeeker() async {
    try {
      var jobseekerData = await _getJobSeeker.getJobSeeker();
      jobseeker.value = jobseekerData;
    } catch ($e) {
      print("Failed to fetch job seeker");
    }
  }
}

class AddJobseeker extends GetxController {
  
}
