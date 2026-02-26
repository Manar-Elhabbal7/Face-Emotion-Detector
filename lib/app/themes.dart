import 'package:flutter/material.dart';

class AppThemes {
  // Colors
  static const Color primary = Color.fromARGB(255, 81, 121, 180);
  //static const Color primary = Color.fromARGB(255, 171, 57, 156);

  static const Color secondary = Color(0xFFFF6B6B);
  static const Color accent = Color(0xFFFFC107);
  static const Color appBarColor = Color.fromARGB(255, 103, 135, 195);
 //static const Color appBarColor = Color.fromARGB(255, 184, 118, 184);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF757575);
  static const Color lightGrey = Color(0xFFF5F5F5);

  // Emotions
  static const Color happy = Color(0xFFFFD93D);
  static const Color sad = Color(0xFF6C63FF);
  static const Color stressed = Color(0xFFFF6B6B);
  static const Color tired = Color(0xFF95E1D3);

  // Text Styles
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: black,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: black,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: black,
  );
  
  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: black,
  );

  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: grey,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: white,
  );
}
