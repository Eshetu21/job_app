import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:job_app/Constants/constants.dart';

class ApplyController extends GetxController {
  final box = GetStorage();
  late final String token;
  final applyLoading = false.obs; 
  final applyError ={}.obs;
  ApplyController() {
    token = box.read('token');
  }
  Future<bool> applyJob(
      {required int jobId, required File coverLetter, required File cv}) async {
    try {
      applyLoading.value=true;
      var request = http.MultipartRequest(
        "POST",
        Uri.parse("${url}js/app/apply/$jobId"),
      );
      request.headers.addAll({
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      });
      request.files.add(
          await http.MultipartFile.fromPath('cover_letter', coverLetter.path));
      request.files.add(await http.MultipartFile.fromPath('cv', cv.path));
      var response = await request.send();
      var responseData = await http.Response.fromStream(response);
      if (response.statusCode == 200) {
        applyLoading.value=false;
        print("Sucessfully applied");
        return true;
      } else {
        var errorMessage = json.decode(responseData.body);
        var errorMessageDecoded = errorMessage["message"];
        applyError["message"]= errorMessageDecoded;
        print("failed $errorMessageDecoded");
        applyLoading.value=false;
        return false;
      }
    } catch ($e) {
      print($e.toString());
      applyLoading.value=false;
      return false;
    }
  }
}
