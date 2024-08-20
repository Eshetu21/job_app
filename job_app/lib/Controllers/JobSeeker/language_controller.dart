import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:job_app/Constants/constants.dart';

class Languagecontroller extends GetxController {
  final box = GetStorage();
  late final String? token;
  late final RxBool updatedSucsessfully = false.obs;
  RxList<dynamic> languages = <dynamic>[].obs;

  Languagecontroller() {
    token = box.read("token");
  }

  Future<void> showlanguages() async {
    final response = await http.get(Uri.parse("${url}showlanguage"), headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token"
    });
    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      if (decodedResponse["language"] != null) {
        final List<dynamic> languageObjects = decodedResponse["language"];
        languages.value = languageObjects.expand((languageObject) {
          if (languageObject["languages"] is List) {
            return languageObject["languages"];
          } else {
            return [languageObject["languages"]];
          }
        }).toList();
      } else {
        print("No languages found");
      }
    } else {
      print(response.statusCode);
      print("Failed to fetch");
    }
  }

  Future<void> updatelanguages({
    required int jobseekerId,
    required List<String> Languages,
  }) async {
    final response = await http.post(
      Uri.parse("${url}updatelanguage/$jobseekerId"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"languages": Languages}),
    );

    if (response.statusCode == 200) {
      updatedSucsessfully.value = true;
      print("Successfully updated languages");
      print(languages);
    } else {
      print(response.statusCode);
      print("Failed to update languages");
    }
  }
}
