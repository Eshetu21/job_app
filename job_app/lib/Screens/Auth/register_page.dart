// ignore_for_file: unnecessary_null_comparison, prefer_const_constructors, prefer_if_null_operators, use_build_context_synchronously, avoid_unnecessary_containers

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Controllers/User/UserController.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _passVisible = false;
  //bool _passConfVisible = false;

  List city = [];

  @override
  void initState() {
    super.initState();
    _userAuthenticationController.clearRegErrorMsg();
    loadDatas();
  }

  Future<void> loadDatas() async {
    final cities = await rootBundle.loadString("assets/json/cities.json");
    var ci = json.decode(cities);

    setState(() {
      city = ci['cities'];
    });
  }

  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final UserAuthenticationController _userAuthenticationController =
      Get.put(UserAuthenticationController());
  void validateAndRegister() async {
    bool hasError = false;
    if (_firstnameController.text.trim().isEmpty) {
      hasError = true;
      _userAuthenticationController.regError["firstname1"] =
          "firstname required";
    }
    if (_lastnameController.text.trim().isEmpty) {
      hasError = true;
      _userAuthenticationController.regError["lastname1"] = "lastname required";
    }
    if (_emailController.text.trim().isEmpty) {
      hasError = true;
      _userAuthenticationController.regError["email1"] = "email required";
    }
    if (_passwordController.text.isEmpty) {
      hasError = true;
      _userAuthenticationController.regError["password1"] = "password required";
    }
    if (_addressController.text.trim().isEmpty) {
      hasError = true;
      _userAuthenticationController.regError["address1"] = "address required";
    }
    /* if (_confirmPasswordController.text.trim().isEmpty) {
      hasError = true;
      _userAuthenticationController.regError["confirm_password"] =
          "*confirm password";
    }
    if (_confirmPasswordController.text.trim() !=
        _passwordController.text.trim()) {
      _userAuthenticationController.regError["match_password"] =
          "*password doesn't match";
      hasError = true;
    } */
    if (!hasError) {
      await _userAuthenticationController.register(
          firstname: _firstnameController.text.trim(),
          lastname: _lastnameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          address: _addressController.text.trim());
      _userAuthenticationController.regLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 50, left: 25, right: 25),
          child: Column(children: [
            Text("Create an Account",
                style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D0140))),
            SizedBox(height: 15),
            Text("Set up a new account",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(color: Color(0xFF524B6B))),
            SizedBox(height: 20),
            Row(),
            Obx(() {
              String? errorText =
                  _userAuthenticationController.regError["firstname1"];
              return TextFormField(
                controller: _firstnameController,
                decoration: InputDecoration(
                    hintText: errorText == null ? "First Name" : errorText,
                    hintStyle: TextStyle(
                        color:
                            errorText == null ? Color(0xFF0D0140) : Colors.red,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: errorText == null ? 16 : 12),
                    contentPadding: EdgeInsets.all(16),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18))),
              );
            }),
            SizedBox(height: 8),
            Obx(() {
              String? errorText =
                  _userAuthenticationController.regError["lastname1"];
              return TextFormField(
                controller: _lastnameController,
                decoration: InputDecoration(
                    hintText: errorText == null ? "Last Name" : errorText,
                    hintStyle: TextStyle(
                        color:
                            errorText == null ? Color(0xFF0D0140) : Colors.red,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: errorText == null ? 16 : 12),
                    contentPadding: EdgeInsets.all(16),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18))),
              );
            }),
            SizedBox(height: 8),
            Obx(() {
              String? errorText =
                  _userAuthenticationController.regError["email"];
              String? errorText1 =
                  _userAuthenticationController.regError["email1"];
              return Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        hintText: errorText1 == null ? "Email" : errorText1,
                        hintStyle: TextStyle(
                            color: errorText1 == null
                                ? Color(0xFF0D0140)
                                : Colors.red,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontSize: errorText1 == null ? 16 : 12),
                        contentPadding: EdgeInsets.all(16),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18))),
                  ),
                  errorText != null
                      ? Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                                _userAuthenticationController.regError["email"],
                                style: GoogleFonts.poppins(
                                    color: Colors.red, fontSize: 12)),
                          ),
                        )
                      : Container()
                ],
              );
            }),
            SizedBox(
              height: 8,
            ),
            Obx(() {
              String? errorTextad =
                  _userAuthenticationController.regError["address1"];
              return DropdownButtonFormField(
                  decoration: InputDecoration(
                      hintText: errorTextad == null ? "City" : errorTextad,
                      hintStyle: GoogleFonts.poppins(
                          color: errorTextad == null
                              ? Color(0xFF0D0140)
                              : Colors.red,
                          fontSize: errorTextad == null ? 16 : 12),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                  items: city
                      .map((city) => DropdownMenuItem(
                          value: city,
                          child: Text(city, style: GoogleFonts.poppins())))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _addressController.text = value.toString();
                    });
                  });

              /*  return DropdownButtonFormField<String>(
                          value: _cities.contains(selectedcity)
                              ? selectedcity
                              : null,
                          items: _cities.map((city) {
                            return DropdownMenuItem(
                              value: city,
                              child: Text(
                                city,
                                style: GoogleFonts.poppins(),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedcity = newValue;
                            });
                          },
                          decoration: InputDecoration(
                              hintText: errorText == null
                                  ? "Select a city"
                                  : errorText,
                              hintStyle: TextStyle(
                                  color: errorText == null
                                      ? Color(0xFF0D0140)
                                      : Colors.red,
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontSize: errorText == null ? 16 : 12),
                              contentPadding: EdgeInsets.all(13),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18))),
                          dropdownColor: Color(0xFFE5E5E5),
                        ); */
            }),
            SizedBox(height: 8),
            Obx(() {
              String? errorText =
                  _userAuthenticationController.regError["password1"];
              String? errorText1 =
                  _userAuthenticationController.regError["password"];
              return Column(
                children: [
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_passVisible,
                    decoration: InputDecoration(
                        hintText: errorText == null ? "Password" : errorText,
                        hintStyle: TextStyle(
                            color: errorText == null
                                ? Color(0xFF0D0140)
                                : Colors.red,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontSize: errorText == null ? 16 : 12),
                        contentPadding: EdgeInsets.all(16),
                        suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _passVisible = !_passVisible;
                              });
                            },
                            child: _passVisible
                                ? Icon(
                                    Icons.visibility_outlined,
                                    color: Color(0xFF60778C),
                                  )
                                : Icon(Icons.visibility_off_outlined,
                                    color: Color(0xFF60778C))),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18))),
                  ),
                  errorText1 != null
                      ? Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                                _userAuthenticationController
                                    .regError["password"],
                                style: GoogleFonts.poppins(
                                    color: Colors.red, fontSize: 12)),
                          ),
                        )
                      : Container()
                ],
              );
            }),
            SizedBox(height: 8),
            /* Obx(() {
                        String? confirmPasswordError =
                            _userAuthenticationController
                                .regError["confirm_password"];
                        String? matchPasswordError =
                            _userAuthenticationController
                                .regError["match_password"];
                        String combinedError = '';
                        if (confirmPasswordError != null) {
                          combinedError += confirmPasswordError;
                        }
                        if (matchPasswordError != null) {
                          if (combinedError.isNotEmpty) {
                            combinedError += ' ';
                          }
                          combinedError += matchPasswordError;
                        }

                        return TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: !_passConfVisible,
                          decoration: InputDecoration(
                            hintText: combinedError.isEmpty
                                ? "Confirm Password"
                                : combinedError,
                            hintStyle: TextStyle(
                              color: combinedError.isEmpty
                                  ? Color(0xFF0D0140)
                                  : Colors.red,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontSize: combinedError == null ? 16 : 12,
                            ),
                            contentPadding: EdgeInsets.all(16),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _passConfVisible = !_passConfVisible;
                                });
                              },
                              child: _passConfVisible
                                  ? Icon(Icons.visibility_outlined,
                                      color: Color(0xFF60778C))
                                  : Icon(Icons.visibility_off_outlined,
                                      color: Color(0xFF60778C)),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                        );
                      }), */
            SizedBox(height: 25),
            Obx(() {
              return _userAuthenticationController.regLoading.value
                  ? CircularProgressIndicator(
                      strokeWidth: 2,
                      strokeAlign: -5,
                    )
                  : GestureDetector(
                      onTap: () {
                        validateAndRegister();
                      },
                      child: Container(
                        width: 266,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color(0xFF130160)),
                        child: Center(
                          child: Text("SIGN UP",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      ),
                    );
            }),
            SizedBox(height: 22),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "You have an account?",
                  style: GoogleFonts.poppins(color: Color(0xFF524B6B)),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _userAuthenticationController.clearRegErrorMsg();
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      splashFactory: NoSplash.splashFactory,
                    ),
                    child: Text("Sign in",
                        style: GoogleFonts.poppins(
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xFFFF9228),
                            color: Color(0xFFFF9228)))),
              ],
            )
          ]),
        ),
      ),
    ));
  }
}
