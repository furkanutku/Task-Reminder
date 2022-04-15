import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

const Color bluishClr = Color(0xFF4e5ae8);
const Color green = Color.fromARGB(255, 40, 181, 110);
const Color pinkClr = Color(0xFFff4667);
const Color white = Colors.white;
const primaryColor = bluishClr;
const Color darkGreyClr = Color(0xFF121212);
const Color darkHeaderClr = Color(0xFF424242);

class AppTheme {
  static final light = ThemeData(
    backgroundColor: white,
    brightness: Brightness.light,
  );

  static final dark = ThemeData(
    backgroundColor: darkGreyClr,
    brightness: Brightness.dark,
  );
}

TextStyle get subHeadingStyle {
  return (GoogleFonts.lato(
      textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: Get.isDarkMode ? Colors.grey[400] : Colors.grey)));
}

TextStyle get headingStyle {
  return (GoogleFonts.lato(
      textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25,
          color: Get.isDarkMode ? Colors.white : Colors.black)));
}

TextStyle get titletyle {
  return (GoogleFonts.lato(
      textStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Get.isDarkMode ? Colors.white : Colors.black)));
}

TextStyle get subTitlestyle {
  return (GoogleFonts.lato(
      textStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 15,
          color: Get.isDarkMode ? Colors.grey[100] : Colors.grey[600])));
}
