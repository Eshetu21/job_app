import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:job_app/Constants/constants.dart';

class ExperienceController extends GetxController {
  RxList<dynamic> experienceDetails = [].obs;
  RxBool updatedSucsessfully = false.obs;
  final createdExperience = false.obs;
  final box = GetStorage();
  late final String? token;

  ExperienceController() {
    token = box.read("token");
  }

  Future<bool> addexperience(
      {required int jobseekerid,
      required String title,
      required String company,
      required String type,
      required String start,
      required String end,
      required String description}) async {
    try {
      createdExperience.value = true;
      var data = {
        "exp_position_title": title,
        "exp_company_name": company,
        "exp_job_type": type,
        "exp_start_date": start,
        "exp_end_date": end,
        "exp_description": description
      };
      var encodedData = data.entries
          .map((e) =>
              "${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}")
          .join('&');
      var response =
          await http.post(Uri.parse("${url}addexperience/$jobseekerid"),
              headers: {
                "Accept": "application/json",
                "Authorization": "Bearer $token",
                "Content-Type": "application/x-www-form-urlencoded",
              },
              body: encodedData);
      if (response.statusCode == 201) {
        await Future.delayed(const Duration(seconds: 2));
        createdExperience.value = false;
        print("Sucssfully added");
        print(encodedData);
        return true;
      } else {
        createdExperience.value = false;
        print("failed");
        print(response.statusCode);
        return false;
      }
    } catch ($e) {
      createdExperience.value = false;
      print($e.toString());
      return false;
    }
  }

  Future<void> showexperience() async {
    var response = await http.get(Uri.parse("${url}showexperience"), headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token"
    });
    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      experienceDetails.value = responseData["experience"];
    } else {
      print("Failed to get education data");
    }
  }

  Future<void> updateexperience(
      {required int jobseekerId,
      required int? experienceId,
      required String title,
      required String company,
      required String type,
      required String start,
      required String end,
      required String description}) async {
    try {
      var data = {
        "exp_position_title": title,
        "exp_company_name": company,
        "exp_job_type": type,
        "exp_start_date": start,
        "exp_end_date": end,
        "exp_description": description
      };
      var encodedData = data.entries
          .map((e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
      var response = await http.put(
          Uri.parse("${url}updateexperience/$jobseekerId/$experienceId"),
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token",
            "Content-Type": "application/x-www-form-urlencoded",
          },
          body: encodedData);
      if (response.statusCode == 200) {
        updatedSucsessfully.value = true;
        print("sucessfully updated");
        print(encodedData);
      }
    } catch ($e) {
      print("failed");
      print($e.toString());
    }
  }
}
