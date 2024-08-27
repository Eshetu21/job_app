import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:job_app/Constants/constants.dart';

class Jobcontroller extends GetxController {
  final box = GetStorage();
  late final String token;
  RxBool sucess = false.obs;
  Jobcontroller() {
    token = box.read('token');
  }
  Future<void> createjob({
    required String title,
    required String city,
    required String type,
    required String sector,
    required String gender,
    required String deadline,
    required String description,
    double? salary,
  }) async {
    var data = {
      "title": title,
      "city": city,
      "type": type,
      "sector": sector,
      "gender": gender,
      "deadline": deadline,
      "description": description
    };
    try {
      var encodedData = data.entries
          .map((e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join("&");
      var response = await http.post(Uri.parse('${url}privatecreatejob'),
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token",
            "Content-Type": "application/x-www-form-urlencoded",
          },
          body: encodedData);
          if(response.statusCode==201){
            sucess.value = true;
            print("Successfully posted a job");
            print(response.body);
          }
    } catch ($e) {
      print("Failed");
      print($e.toString());
    }
  }
}
