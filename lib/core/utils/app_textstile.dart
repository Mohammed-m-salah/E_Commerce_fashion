import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyle {
  static TextStyle h1 = GoogleFonts.poppins(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      height: 1.2,
      letterSpacing: -0.5);
  static TextStyle h2 = GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      height: 1.2,
      letterSpacing: -0.5);
  static TextStyle h3 = GoogleFonts.poppins(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      height: 1.2,
      letterSpacing: -0.5);
  static TextStyle h4 = GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.2,
      letterSpacing: -0.5);

  // body text
  static TextStyle bodylarge = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
  static TextStyle bodymedium = GoogleFonts.poppins(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
  );

  static TextStyle bodysmall = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  //button text
  static TextStyle buttonLarge = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );
  static TextStyle buttonmedium = GoogleFonts.poppins(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );
  static TextStyle buttonsmall = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );
  //label text
  static TextStyle labelLarge = GoogleFonts.poppins(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );
  static TextStyle labelmedium = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );
  static TextStyle labelsmall = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );
  //helper  function  for color variations
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  static TextStyle withwight(TextStyle style, FontWeight wight) {
    return style.copyWith(fontWeight: wight);
  }
}
