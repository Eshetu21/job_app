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
  PrivateclientController() {
    token = box.read("token");
  }
  Future<void> createprivateclient() async {
    final response = await http.post(Uri.parse("${url}createprivateclient"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        });
    if (response.statusCode == 201) {
      print("sucessfully created privaeclient");
       PrivateclientController privateClientController = Get.find<PrivateclientController>();
      await privateClientController.getPrivateJobs();
    } else {
      print(response.statusCode);
      print(token);
      print("failed");
    }
  }

  Future<void> getPrivateJobs() async {
    final response = await http.get(Uri.parse("${url}pc/job/get"), headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token"
    });
    if (response.statusCode == 200) {
      print("sucessfully fetched job");
      privatejobs.value = json.decode(response.body)["jobs"];
    } else {
      print(response.statusCode);
      print(token);

      print(response.body);
    }
  }
}
