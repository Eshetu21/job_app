// ignore_for_file: prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivateAccept extends StatefulWidget {
  const PrivateAccept({super.key});

  @override
  State<PrivateAccept> createState() => _PrivateAcceptState();
}

class _PrivateAcceptState extends State<PrivateAccept> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
                "Write a response indicating that the job posting has been accepted.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    color: Color(0xFF524B6B), fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
          ],
        ),
      )),
    );
  }
}
