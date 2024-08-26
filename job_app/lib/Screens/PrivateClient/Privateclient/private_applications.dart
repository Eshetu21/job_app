import 'package:flutter/material.dart';

class PrivateApplications extends StatefulWidget {
  const PrivateApplications({super.key});

  @override
  State<PrivateApplications> createState() => _PrivateApplicationsState();
}

class _PrivateApplicationsState extends State<PrivateApplications> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text("My Applications"));
  }
}
