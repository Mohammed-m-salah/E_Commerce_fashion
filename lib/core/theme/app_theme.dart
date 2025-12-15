import 'package:flutter/material.dart';

class AppThemes {
// ========================= COLORS =========================
  static const Color primarycolor = Color(0xFFff5722);
  static const Color secondarycolor = Color(0xff5A96E3);
  static const Color greycolor = Color(0xffE5E9EC);

// ========================= LIGHT THEME =========================
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primarycolor,
    scaffoldBackgroundColor: Colors.white,

// AppBar
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),

    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: primarycolor,
      primary: primarycolor,
      brightness: Brightness.light,
      surface: Colors.white,
    ),
    cardColor: Colors.white,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primarycolor,
      unselectedItemColor: Colors.grey,
    ),

// Text Theme
    textTheme: TextTheme(
      bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      bodyMedium: TextStyle(fontSize: 16),
      bodySmall: TextStyle(fontSize: 14, color: Colors.grey),
    ),

// Elevated Button Style
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primarycolor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        minimumSize: Size(double.infinity, 48),
        textStyle: TextStyle(fontWeight: FontWeight.bold),
      ),
    ),

// TextField input decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: greycolor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      hintStyle: TextStyle(
        color: Colors.grey,
        fontSize: 14,
      ),
    ),
  );

// ========================= DARK THEME =========================
  static ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      primaryColor: primarycolor,
      scaffoldBackgroundColor: Color(0xff121212),
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xff121212),
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        bodyMedium: TextStyle(fontSize: 16),
        bodySmall: TextStyle(fontSize: 14, color: Colors.grey),
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primarycolor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: Size(double.infinity, 48),
        ),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primarycolor,
        primary: primarycolor,
        brightness: Brightness.dark,
        surface: Colors.black,
      ),
      cardColor: Colors.black,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color(0xff1E1E1E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: primarycolor,
          unselectedItemColor: Colors.grey));
}
