// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:job_app/Screens/GetStarted/loading_screen.dart';
import 'package:job_app/Screens/Profiles/profiles.dart';

void main() async {
  await GetStorage.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final token = box.read("token");
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: /* token != null ? Profiles() :  */LoadingScreen());
  }
}
