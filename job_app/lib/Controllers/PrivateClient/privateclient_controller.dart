import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:job_app/Constants/constants.dart';

class PrivateclientController extends GetxController {
  final box = GetStorage();
  late final String token;
  RxMap<String, dynamic> privateclient = <String, dynamic>{}.obs;
  RxList<dynamic> privatejobs = <dynamic>[].obs;
  RxList privateApplications = RxList<dynamic>();
  RxList privateApplicationsJobSeeker = RxList<dynamic>();
  RxList privateApplicationsJob = RxList<dynamic>();
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
      print(token);
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
      print("Successfully fetched applications");
      var responseData = json.decode(response.body);
      privateApplications.value = responseData["applications"];
      privateApplicationsJobSeeker.clear();
      privateApplicationsJob.clear();
      for (var application in privateApplications) {
        privateApplicationsJobSeeker.add(application["jobseeker"]);
        privateApplicationsJob.add(application["job"]);
      }
      print("Privateclient applications: $privateApplications");
      print("Privateclient jobseekers: $privateApplicationsJobSeeker");
      print("Privateclient jobs: $privateApplicationsJob");
    }
  } catch (e) {
    print(e.toString());
  }
}

}
