// ignore_for_file: prefer_is_empty, prefer_interpolation_to_compose_strings

import 'dart:math';

import 'package:flutter/services.dart';

class DateTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text;
    String formattedText = '';

    if (newText.length >= 1) {
      formattedText += newText.substring(0, min(newText.length, 2));
    }
    if (newText.length >= 3) {
      formattedText += '/' + newText.substring(2, min(newText.length, 4));
    }
    if (newText.length >= 5) {
      formattedText += '/' + newText.substring(4, min(newText.length, 8));
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
