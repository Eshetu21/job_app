// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:job_app/Constants/constants.dart';
import 'package:job_app/Controllers/Profile/ProfileController.dart';
import 'package:job_app/Screens/Auth/login_page.dart';
import 'package:job_app/Widgets/navigateprofile.dart';

class UserAuthenticationController extends GetxController {
  final ProfileController _profileController = Get.put(ProfileController());
  final regLoading = false.obs;
  final logLoading = false.obs;
  final regError = {}.obs;
  final logError = {}.obs;

  final token = ''.obs;
  final userId = ''.obs;
  final box = GetStorage();

  void clearRegErrorMsg() {
    regError.clear();
  }

  void clearLogErrorMsg() {
    logError.clear();
  }

  Future<bool> register(
      {required String firstname,
      required String lastname,
      required String email,
      required String password,
      required String address}) async {
    try {
      regLoading.value = true;
      var data = jsonEncode({
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "password": password,
        "address": address
      });
      var response = await http.post(Uri.parse("${url}register"),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json"
          },
          body: data);

      if (response.statusCode == 201) {
        regLoading.value = false;
        token.value = json.decode(response.body)["token"];
        box.write("token", token.value);
        regError.clear();
        print('Registration successful');
        await Future.delayed(Duration(seconds: 1));
        return true;
      } else if (response.statusCode == 422) {
        var errors = json.decode(response.body)['errors'];
        regError.value = errors.map((key, value) {
          return MapEntry(key, (value as List<dynamic>).join(' '));
        });
        await Future.delayed(Duration(seconds: 2));
        regLoading.value = false;
        return false;
      } else {
        var responseData = json.decode(response.body);
        regError.clear();
        responseData['errors'].forEach((key, value) {
          regError[key] = value[0];
        });
        regLoading.value = false;
        print({response.body});
        await Future.delayed(Duration(seconds: 2));
        regLoading.value = false;
        return false;
      }
    } catch (e) {
      regLoading.value = false;
      print(e.toString());
      return false;
    }
  }

  Future login({
    required String email,
    required String password,
  }) async {
    try {
      logLoading.value = true;
      var data = jsonEncode({
        "email": email,
        "password": password,
      });
      var response = await http.post(Uri.parse('${url}login'),
          headers: {
            'Accept': 'application/json',
            "Content-Type": "application/json",
          },
          body: data);
          print(response);
      if (response.statusCode == 200) {
        token.value = json.decode(response.body)["token"];
        box.write("token", token.value);
        userId.value = json.decode(response.body)["message"]["id"].toString();
        logError.clear();
        await _profileController.fetchProfiles();
        navigateBasedOnProfile();
        print(token);
        print('Login successful');
        print(userId);
      } else if (response.statusCode == 401) {
        logError.clear();
        logError["general"] = "Invalid credentials";
        logLoading.value = false;
        print('Invalid credentials');
      }
    } catch (e) {
      logLoading.value = false;
      print(e.toString());
    }
  }

  void logout() {
    logLoading.value = false;
    box.remove('token');
    _profileController.profiles.clear();
    token.value = '';
    userId.value = '';
    Get.offAll(() => LoginPage());
  }

  RxString getUserId() {
    return userId;
  }
}
