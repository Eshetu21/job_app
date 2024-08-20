// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_app/Widgets/dateformat.dart';

Widget buildTextFormField(String label, TextEditingController controller) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      alignLabelWithHint: true,
      labelStyle: TextStyle(color: Color(0xFF0D0140)),
      label: Text(label, style: GoogleFonts.poppins()),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
    ),
    maxLines: label == "Description" ? 5 : 1,
  );
}

Widget buildDateField(String label, TextEditingController controller) {
  return TextField(
    controller: controller,
    inputFormatters: [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(10),
      DateTextInputFormatter(),
    ],
    decoration: InputDecoration(
      labelStyle: TextStyle(color: Color(0xFF0D0140)),
      label: Text(label, style: GoogleFonts.poppins()),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      hintText: "DD/MM/YY",
      hintStyle: TextStyle(
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
    ),
  );
}
