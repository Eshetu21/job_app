import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:job_app/Constants/constants.dart';

class SkillController extends GetxController {
  final box = GetStorage();
  late final String? token;
  late final RxBool updatedSucsessfully = false.obs;
  RxList<dynamic> skills = <dynamic>[].obs;
  SkillController() {
    token = box.read("token");
  }
  Future<void> showskills() async {
    final response = await http.get(Uri.parse('${url}showskill'), headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token"
    });
    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      final List<dynamic> skillObjects = decodedResponse["skills"];
      skills.value = skillObjects.map((skillObjects) {
        return skillObjects["skills"];
      }).toList();
      print(decodedResponse);
      print(skills);
    } else {
      print(response.statusCode);
      print("Failed to fetch");
    }
  }

  Future<void> addskills(
      {required int id, required List<String> skills}) async {
    final response = await http.post(Uri.parse('${url}controlskill/$id'),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"skills": skills}));
    if (response.statusCode == 200) {
      updatedSucsessfully.value = true;
      print("sucessfully updated");
    } else {
      print("Failed to update skill");
    }
  }
}
