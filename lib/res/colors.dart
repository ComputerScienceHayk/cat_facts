import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color transparent = Colors.transparent;
const Color white = Colors.white;
const Color black = Colors.black;
const Color grey = Colors.grey;

class CustomShadow {
  static List<BoxShadow> defaultShadow() {
    return [
      BoxShadow(
          color: black.withOpacity(.07),
          offset: const Offset(0, 1),
          blurRadius: 4,
          spreadRadius: 4,
      )
    ];
  }
}

class StyleText {
  static TextStyle blackText(double fontSize, FontWeight fontWeight,
      {bool underline = false}) {
    return GoogleFonts.openSans(
        color: black,
        fontSize: fontSize,
        fontWeight: fontWeight,
        decoration: underline ? TextDecoration.underline : TextDecoration.none,
    );
  }
}
