import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:job_app/Constants/constants.dart';

class PrivateclientController extends GetxController {
  final box = GetStorage();
  late final String token;
  RxList<dynamic> skills = <dynamic>[].obs;
  RxList<dynamic> languages = <dynamic>[].obs;
  RxMap<String, dynamic> privateclient = <String, dynamic>{}.obs;
  RxList<dynamic> privatejobs = <dynamic>[].obs;
  RxList privateApplications = RxList<dynamic>();
  RxList privateApplicationsJobSeeker = RxList<dynamic>();
  RxList privateApplicationsJob = RxList<dynamic>();
  final privateGetJobseeker = {}.obs;
  final getJobseekerEducation = [].obs;
  final getJobseekerExperience = [].obs;
  final getJobseekerSkill = [].obs;
  final getJobseekerLanguage = [].obs;
  final acceptLoading = false.obs;
  final acceptError = {}.obs;
  final rejectLoading = false.obs;
  final rejectError = {}.obs;
  PrivateclientController() {
    token = box.read("token");
  }
  Future<bool> createprivateclient() async {
    final response = await http.post(Uri.parse("${url}pc/create"), headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token"
    });
    if (response.statusCode == 201) {
      print("sucessfully created privaeclient");
      PrivateclientController privateClientController =
          Get.find<PrivateclientController>();
      await privateClientController.getPrivateJobs();
      return true;
    } else {
      print(response.statusCode);
      print("failed");
      return false;
    }
  }

  Future<void> getPrivateJobs() async {
    final response = await http.get(Uri.parse("${url}pc/job/get"), headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token"
    });
    if (response.statusCode == 200) {
      //print("sucessfully fetched job");
      //print(json.decode(response.body)["jobs"]);
      privatejobs.value = json.decode(response.body)["jobs"];
    } else {
      print(response.statusCode);
      print(token);

      print(response.body);
    }
  }

  Future<void> getApplications() async {
    try {
      var response = await http.get(Uri.parse("${url}pc/app/get"), headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      });
      if (response.statusCode == 200) {
        // print("Successfully fetched applications");
        var responseData = json.decode(response.body);
        privateApplications.value = responseData["applications"];
        /* privateApplicationsJobSeeker.clear();
        privateApplicationsJob.clear(); */
        for (var application in privateApplications) {
          privateApplicationsJobSeeker.add(application["jobseeker"]);
          privateApplicationsJob.add(application["job"]);
        }
        /*  print("Privateclient applications: $privateApplications");
        print("Privateclient jobseekers: $privateApplicationsJobSeeker");
        print("Privateclient jobs: $privateApplicationsJob"); */
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool> acceptApplication(
      {required int jobId,
      required int appId,
      required String statement}) async {
    try {
      acceptLoading.value = true;
      var data = json.encode({"statement": statement});
      var response =
          await http.put(Uri.parse("${url}pc/app/accept/$jobId/$appId"),
              headers: {
                "Accept": "application/json",
                "Content-Type": "application/json",
                "Authorization": "Bearer $token"
              },
              body: data);
      if (response.statusCode == 200) {
        print("sucessfully accepted");
        acceptLoading.value = false;
        return true;
      } else {
        print(response.body);
        var jsonResponse = json.decode(response.body);
        String errorMessage = jsonResponse['message'];
        acceptError["message"] = errorMessage;
        acceptLoading.value = false;
        return false;
      }
    } catch ($e) {
      print($e.toString());
      acceptLoading.value = false;
      return false;
    }
  }
  Future<bool> rejectApplication(
      {required int jobId,
      required int appId,
      required String statement}) async {
    try {
      rejectLoading.value = true;
      var data = json.encode({"statement": statement});
      var response =
          await http.put(Uri.parse("${url}pc/app/reject/$jobId/$appId"),
              headers: {
                "Accept": "application/json",
                "Content-Type": "application/json",
                "Authorization": "Bearer $token"
              },
              body: data);
      if (response.statusCode == 200) {
        print("sucessfully accepted");
        rejectLoading.value = false;
        return true;
      } else {
        print(response.body);
        var jsonResponse = json.decode(response.body);
        String errorMessage = jsonResponse['message'];
        rejectError["message"] = errorMessage;
        rejectLoading.value = false;
        return false;
      }
    } catch ($e) {
      print($e.toString());
      rejectLoading.value = false;
      return false;
    }
  }

  Future<void> getJobSeeker({required int jobSeekerId}) async {
    try {
      var response =
          await http.get(Uri.parse("${url}p/js/$jobSeekerId"), headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      });
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        privateGetJobseeker.value = responseData;
        // print("private jobseeker $privateGetJobseeker");
        getJobseekerEducation.value =
            privateGetJobseeker["jobseeker"]["educations"];
        //  print("jobseeker Education $getJobseekerEducation");
        getJobseekerExperience.value =
            privateGetJobseeker["jobseeker"]["experiences"] ?? [];
        //  print("jobseeker Experience $getJobseekerExperience");
        final List<dynamic> skillObjects =
            privateGetJobseeker["jobseeker"]["skills"];
        skills.value = skillObjects.map((skillObjects) {
          return skillObjects["skills"];
        }).toList();
        final List<dynamic> languageObjects =
            privateGetJobseeker["jobseeker"]["languages"];
        languages.value = languageObjects.map((languageObjects) {
          return languageObjects["languages"];
        }).toList();
      } else {
        print("failed ${response.body}");
      }
    } catch ($e) {
      print($e.toString());
    }
  }
}
