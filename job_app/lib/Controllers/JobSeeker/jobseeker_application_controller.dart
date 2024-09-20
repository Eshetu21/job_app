import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:job_app/Constants/constants.dart';

class ApplicationController extends GetxController {
  final box = GetStorage();
  final token = ''.obs;
  RxList<dynamic> myApplications = <dynamic>[].obs;
  ApplicationController() {
    token.value = box.read("token");
  }
  Future<void> getApplication() async {
    try {
      var response = await http.get(Uri.parse("${url}js/app/get"), headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      });
      if(response.statusCode==200){
        var responseData = json.decode(response.body);
        myApplications.value = responseData["applications"];
      }
    } catch ($e) {
      print($e.toString());
    }
  }
}
