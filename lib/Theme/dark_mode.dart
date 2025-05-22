import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  fontFamily: 'Circular book',
  useMaterial3: true,
  colorScheme: ColorScheme.dark(
    surface: Colors.black87,
    primary: HexColor("ABC4FF"),
    secondary: HexColor("B6CCFE"),
    inversePrimary: HexColor("EDF2FB"),
  ),
);
