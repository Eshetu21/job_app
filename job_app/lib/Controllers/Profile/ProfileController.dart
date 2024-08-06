import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:job_app/constants/constants.dart';

class GetProfile {
  Future<Map<String, dynamic>> getProfile() async {
    final box = GetStorage();
    final token = box.read("token");

    var response = await http.get(Uri.parse("${url}profile"), headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    });

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      return responseData['profiles'];
    } else {
      throw Exception("Failed to get profiles ");
    }
  }
}

class ProfileController extends GetxController {
  RxMap<String, dynamic> profiles = <String, dynamic>{}.obs;
  final GetProfile _getProfile = Get.put(GetProfile());
  RxBool isloading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfiles();
  }

  Future<void> fetchProfiles() async {
    try {
      var profileData = await _getProfile.getProfile();
      profiles.value = profileData;
      isloading.value = false;
    } catch ($e) {
      print("Failed to get profiles");
    }
  }
}
