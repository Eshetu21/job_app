import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:job_app/Constants/constants.dart';

class CompanyController extends GetxController {
  final box = GetStorage();
  late final String? token;
  RxMap<String, dynamic> company = <String, dynamic>{}.obs;
  RxList<dynamic> companyJobs = <dynamic>[].obs;
  RxBool sucessfullyAdded = false.obs;
  final companyCreateError = {}.obs;
  RxList companyApplications = RxList<dynamic>();
  RxList companyApplicationsJobSeeker = RxList<dynamic>();
  RxList companyApplicationsJob = RxList<dynamic>();
  final companyGetJobseeker = {}.obs;
  final getJobseekerEducation = [].obs;
  final getJobseekerExperience = [].obs;
  final getJobseekerSkill = [].obs;
  final getJobseekerLanguage = [].obs;
  final acceptLoading = false.obs;
  final acceptError = {}.obs;
  CompanyController() {
    token = box.read("token");
  }
  Future<void> createCompany({
    required String name,
    required File logo,
    required String phone,
    required String address,
    required String description,
  }) async {
    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse("${url}c/create"),
      );
      request.headers.addAll({
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      });
      request.fields["company_name"] = name;
      request.fields["company_phone"] = phone;
      request.fields["company_address"] = address;
      request.fields["company_description"] = description;

      request.files
          .add(await http.MultipartFile.fromPath('company_logo', logo.path));
      var response = await request.send();
      if (response.statusCode == 201) {
        print("Sucessfully created company");
        var responsebody = await http.Response.fromStream(response);
        sucessfullyAdded.value = true;
        print(responsebody.body);
      } else {
        print("Failed to create company");
        var responsebody = await http.Response.fromStream(response);
        companyCreateError.clear();
        var responseData = json.decode(responsebody.body);
        responseData['message'].forEach((key, value) {
          companyCreateError[key] = value[0];
          print(" backend $companyCreateError");
        });
      }
    } catch ($e) {
      print($e);
    }
  }

  Future<void> fetchCompany() async {
    var response = await http.get(Uri.parse("${url}c/get"), headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token"
    });
    if (response.statusCode == 200) {
      print(response.body);
      company.value = json.decode(response.body)["company"];
      print("Sucessfully fetched company");
      print(company);
    } else {
      print("failed to fetch");
    }
  }

  Future<void> fetchCompanyJob() async {
    var response = await http.get(Uri.parse("${url}c/job/get"), headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token"
    });
    if (response.statusCode == 200) {
      companyJobs.value = json.decode(response.body)["jobs"];
      print("Sucessfully fetched company jobs");
      print(companyJobs);
    } else {
      print("Failed to fetch company jobs");
      print(response.statusCode);
    }
  }

  Future<void> getCompanyApplications() async {
    try {
      var response = await http.get(Uri.parse("${url}c/app/get"), headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      });
      if (response.statusCode == 200) {
        // print("Successfully fetched applications");
        var responseData = json.decode(response.body);
        companyApplications.value = responseData["applications"];
        /* privateApplicationsJobSeeker.clear();
        privateApplicationsJob.clear(); */
        for (var application in companyApplications) {
          companyApplicationsJobSeeker.add(application["jobseeker"]);
          companyApplicationsJob.add(application["job"]);
        }
        /*  print("Privateclient applications: $privateApplications");
        print("Privateclient jobseekers: $privateApplicationsJobSeeker");
        print("Privateclient jobs: $privateApplicationsJob"); */
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
