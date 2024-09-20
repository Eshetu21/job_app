// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivateViewApplicant extends StatefulWidget {
  final Map application;
  const PrivateViewApplicant({super.key, required this.application});

  @override
  State<PrivateViewApplicant> createState() => _PrivateViewApplicantState();
}

class _PrivateViewApplicantState extends State<PrivateViewApplicant> {
  Future<void> openPdf(String url) async {
    Uri pdfUri = Uri.parse(url);
    if (await canLaunchUrl(pdfUri)) {
      await launchUrl(pdfUri);
    } else {
      throw "Couldn't launch url";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    Text("Job Details",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    Divider(),
                    Row(
                      children: [
                        Text("Title: ",
                            style: GoogleFonts.poppins(fontSize: 16)),
                        Text("${widget.application["job"]["title"]}",
                            style: GoogleFonts.poppins()),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Sector: ",
                            style: GoogleFonts.poppins(fontSize: 16)),
                        Text("${widget.application["job"]["sector"]}",
                            style: GoogleFonts.poppins()),
                      ],
                    ),
                    Row(
                      children: [
                        Text("City: ",
                            style: GoogleFonts.poppins(fontSize: 16)),
                        Text("${widget.application["job"]["city"]}",
                            style: GoogleFonts.poppins()),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    Text("Applicant Details",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    Divider(),
                    Row(
                      children: [
                        Text("Name: ",
                            style: GoogleFonts.poppins(fontSize: 16)),
                        Text(
                            "${widget.application["jobseeker"]["firstname"]} ${widget.application["jobseeker"]["lastname"]}",
                            style: GoogleFonts.poppins()),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Email: ",
                            style: GoogleFonts.poppins(fontSize: 16)),
                        Text("${widget.application["jobseeker"]["email"]}",
                            style: GoogleFonts.poppins()),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Address: ",
                            style: GoogleFonts.poppins(fontSize: 16)),
                        Text("${widget.application["jobseeker"]["address"]}",
                            style: GoogleFonts.poppins()),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    Text("Documents",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    Divider(),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text("CV"),
                      trailing: Icon(Icons.picture_as_pdf,color: Colors.red),
                      onTap: (){
                        openPdf(widget.application["cv"]);
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text("Cover Letter"),
                      trailing: Icon(Icons.picture_as_pdf,color: Colors.red),
                      onTap: (){
                        openPdf(widget.application["cover_letter"]);
                      },
                    )
                  ],
                ),
              ),
            ),
            Text("CV: ${widget.application["cv"]}"),
            Text("Cover letter: ${widget.application["cover_letter"]}"),
          ],
        ),
      ),
    )));
  }
}
