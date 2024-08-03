import 'dart:convert';

import 'package:flutter/services.dart';

class LoadCities {
  static Future<List<String>> loadcities() async {
    String response = await rootBundle.loadString("assets/json/cities.json");
   final List<String> cities = List<String>.from(jsonDecode(response));
    return cities;
  }
}
