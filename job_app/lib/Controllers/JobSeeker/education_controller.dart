import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:job_app/constants/constants.dart';
import 'package:http/http.dart' as http;

class EducationController extends GetxController {
  RxMap<String, dynamic> education = <String, dynamic>{}.obs;
  final box = GetStorage();
  late final String? token;
  late final int jobseekerId;

  EducationController() {
    token = box.read("token");
    jobseekerId = box.read("jobseekerId");
  }

  Future<Map<String, dynamic>> showeducation({int? jobseekerId}) async {
    var response = await http.get(Uri.parse("${url}showeducation"), headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token"
    });
    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      return responseData;
    } else {
      throw Exception("Failed to get jobseeker data");
    }
  }
  
  Future addeducation(
      {required String institution,
      required String field,
      required String eduLevel,
      required String eduStart,
      String? eduEnd,
      String? eduDescription}) async {
    var educationData = {
      "school_name": institution,
      "field": field,
      "education_level": eduLevel,
      "edu_start_date": eduStart,
      "edu_end_date": eduEnd,
      "education_description": eduDescription
    };
    var response = await http.post(Uri.parse("${url}addeducation"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        },
        body: educationData);
    if (response.statusCode == 201) {
      print("sucessfully uploaded educations");
      print(response.body);
    }
  }
}
