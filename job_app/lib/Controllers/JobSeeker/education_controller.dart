import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:job_app/constants/constants.dart';
import 'package:http/http.dart' as http;

class EducationController extends GetxController {
  RxList<dynamic> educationDetails =[].obs;
  final box = GetStorage();
  late final String? token;
  late final int jobseekerId;


  EducationController() {
    token = box.read("token");
    jobseekerId = box.read("jobseekerId");
  }

  Future<void> createeducation(
      {required int jobseekerid,
      required String institution,
      required String field,
      required String eduLevel,
      required String eduStart,
      required String eduEnd,
      required String eduDescription}) async {
    try {
      var data = {
        "school_name": institution,
        "field": field,
        "education_level": eduLevel,
        "edu_start_date": eduStart,
        "edu_end_date": eduEnd,
        "description": eduDescription
      };
      var encodedData = data.entries
          .map((e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
      final response =
          await http.post(Uri.parse("${url}addeducation/$jobseekerid"),
              headers: {
                "Accept": "application/json",
                "Authorization": "Bearer $token",
                "Content-Type": "application/x-www-form-urlencoded",
              },
              body: encodedData);
      if (response.statusCode == 201) {
        print("Education created");
        print(encodedData);
      }
    } catch ($e) {
      print("Failed");
      print($e.toString());
    }
  }

  Future<List<dynamic>> showeducation() async {
    var response = await http.get(Uri.parse("${url}showeducation"), headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token"
    });
    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      print("api $responseData");
     educationDetails.value = responseData["education"];
     return educationDetails;
    } else {
      print("Failed to get education data");
      return [];
    }
  }

  Future updateeducation(
      {required int jobseekerid,
      required int educationid,
      String? institution,
      String? field,
      String? eduLevel,
      String? eduStart,
      String? eduEnd,
      String? eduDescription}) async {
    try {
      var data = {
        "school_name": institution ?? "",
        "field": field ?? "",
        "education_level": eduLevel ?? "",
        "edu_start_date": eduStart ?? "",
        "edu_end_date": eduEnd ?? "",
        "description": eduDescription ?? ""
      };
      var encodedData = data.entries
          .map((e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
      final response = await http.put(
          Uri.parse("${url}updateeducation/$jobseekerid/$educationid"),
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token",
            "Content-Type": "application/x-www-form-urlencoded",
          },
          body: encodedData);
      if (response.statusCode == 200) {
        print("Education updated");
        print(encodedData);
      }
    } catch ($e) {
      print("Failed");
      print($e.toString());
    }
  }
}
