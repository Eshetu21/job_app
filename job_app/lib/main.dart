import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_app/Screens/GetStarted/loading_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
        debugShowCheckedModeBanner: false, home: LoadingScreen());
  }
}
