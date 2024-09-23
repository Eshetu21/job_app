// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:job_app/Constants/constants.dart';
import 'package:job_app/Controllers/Profile/ProfileController.dart';
import 'package:job_app/Screens/Auth/login_page.dart';
import 'package:job_app/Screens/Auth/register_email_very.dart';
import 'package:job_app/Screens/Auth/verify_email.dart';
import 'package:job_app/Widgets/navigateprofile.dart';

class UserAuthenticationController extends GetxController {
  final ProfileController _profileController = Get.put(ProfileController());
  final regLoading = false.obs;
  final logLoading = false.obs;
  final otpLoading = false.obs;
  final otpVerifyLoading = false.obs;
  final passwordResetLoading = false.obs;
  final regError = {}.obs;
  final logError = {}.obs;
  final verifyEmailError = {}.obs;
  final verifyOTPError = {}.obs;
  final passwordResetError = {}.obs;

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
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: data);

      if (response.statusCode == 201) {
        token.value = json.decode(response.body)["token"];
        box.write("token", token.value);
        regError.clear();
        print('Registration successful');
        await Future.delayed(Duration(seconds: 1));
        regLoading.value = false;
        Get.to(RegisterVerifyEmail(email: email));
        print(response.body);
        return true;
      } else if (response.statusCode == 422) {
        print(response.body);
        var errors = json.decode(response.body)['errors'];
        regError.value = errors.map((key, value) {
          return MapEntry(key, (value as List<dynamic>).join(' '));
        });
        regLoading.value = false;
        return false;
      } else {
        var responseData = json.decode(response.body);
        regError.clear();
        responseData['errors'].forEach((key, value) {
          regError[key] = value[0];
          var passwordError = json.decode(response.body)["errors"]["password"];
          if (passwordError is List) {
            regError["password"] = passwordError.join(', ');
          } else {
            regError["password"] = passwordError;
          }
          print(" backend $regError");
        });

        regLoading.value = false;
        return false;
      }
    } catch (e) {
      print("error");
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
        if (json.decode(response.body)["message"]["email_verified"] == 1) {
          await _profileController.fetchProfiles();
          navigateBasedOnProfile();
          logLoading.value = false;
        }
        if (json.decode(response.body)["message"]["email_verified"] == 0) {
          String email = json.decode(response.body)["message"]["email"];
          Get.to(VerifyEmail(email: email));
          logLoading.value = false;
        }

        print(token);
        print('Login successful');
        print(userId);
      } else {
        logError.clear();
        var emailError = json.decode(response.body)["errors"]["email"];
        var passwordError = json.decode(response.body)["errors"]["password"];
        print(emailError);
        print(passwordError);
        if (emailError is List) {
          logError["email"] = emailError.join(', ');
        } else {
          logError["email"] = emailError;
          if (passwordError is List) {
            logError["password"] = passwordError.join(', ');
          } else {
            logError["password"] = passwordError;
          }
        }
        logLoading.value = false;
      }
    } catch (e) {
      logLoading.value = false;
      print(e.toString());
    }
  }

  void logout() async {
    logLoading.value = false;
    await box.erase();
    await Get.deleteAll();
    Get.offAll(() => LoginPage());
  }

  RxString getUserId() {
    return userId;
  }

  Future<bool> forgotPassword({required String email}) async {
    try {
      otpLoading.value = true;
      var data = jsonEncode({"email": email});
      final response = await http.post(Uri.parse("${url}p/u/forgetpassword"),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          },
          body: data);
      if (response.statusCode == 200) {
        print("Successfully sent OTP code");
        otpLoading.value = false;
        return true;
      } else {
        var jsonResponse = json.decode(response.body);
        String errorMessage = jsonResponse['message'];
        verifyEmailError['email'] = errorMessage;
        otpLoading.value = false;
        return false;
      }
    } catch ($e) {
      otpLoading.value = false;
      print($e.toString());
      return false;
    }
  }

  Future<bool> verifyOTP({required String email, required int pin}) async {
    try {
      otpVerifyLoading.value = true;
      var data = json.encode({"email": email, "pincode": pin});
      var response = await http.post(Uri.parse('${url}p/u/verifypincode'),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json"
          },
          body: data);
      if (response.statusCode == 200) {
        print("Sucessfully verified OTP");
        otpVerifyLoading.value = false;
        return true;
      } else {
        var jsonResponse = json.decode(response.body);
        String errorMessage = jsonResponse["message"];
        verifyOTPError["otp"] = errorMessage;
        return false;
      }
    } catch ($e) {
      print($e.toString());
      return false;
    }
  }

  Future<bool> checkPIN({required int pin}) async {
    try {
      otpVerifyLoading.value = true;
      var data = jsonEncode({"pincode": pin});
      var response = await http.post(Uri.parse('${url}checkpincode'),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: data);
      if (response.statusCode == 200) {
        print("Sucessfully verified OTP");
        otpVerifyLoading.value = false;
        return true;
      } else {
        var jsonResponse = json.decode(response.body);
        String errorMessage = jsonResponse["message"];
        verifyOTPError["otp"] = errorMessage;
        return false;
      }
    } catch ($e) {
      print($e.toString());
      return false;
    }
  }

  Future<bool> resetpassword(
      {required String email, required String newPassword}) async {
    try {
      passwordResetLoading.value = true;
      var data = jsonEncode({"email": email, "newpassword": newPassword});
      var response = await http.post(Uri.parse('${url}p/u/changepassword'),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json"
          },
          body: data);
      if (response.statusCode == 200) {
        print("Sucessfully updated password");
        return true;
      } else {
        var jsonResponse = json.decode(response.body);
        String errorMessage = jsonResponse["message"];
        passwordResetError["passwordreset"] = errorMessage;
        print(response.body);
        return false;
      }
    } catch ($e) {
      print($e.toString());
      return false;
    }
  }

  Future<bool> sendpin() async {
    try {
      otpVerifyLoading.value = true;
      var response = await http.post(Uri.parse('${url}sendpincode'), headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      });
      if (response.statusCode == 200) {
        print("sucessfully sent pincode");
        otpVerifyLoading.value = false;
        return true;
      } else {
        print("failed to send pincode");
        print(response.body);
        otpVerifyLoading.value = false;
        return false;
      }
    } catch ($e) {
      print($e.toString());
      return false;
    }
  }
}
