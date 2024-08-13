import 'dart:convert';
import 'dart:ffi';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:job_app/Constants/constants.dart';

class SkillController extends GetxController {
  final box = GetStorage();
  late final String? token;
  late final int jobseekerId;

  SkillController() {
    token = box.read("token");
    jobseekerId = box.read("jobseekerId");
  }
  Future<void> createskill(
      {required int id, required List<String> skills}) async {
    final response = await http.post(Uri.parse('${url}controlskill'),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({'skills': skills}));

    if (response.statusCode == 201) {
      print("sucessfully updated");
      print(response.body);
    } else {
      print("Failed to update skill");
    }
  }
}
