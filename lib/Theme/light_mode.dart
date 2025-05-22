import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

ThemeData lightMode = ThemeData(
  fontFamily: 'Circular book',
  useMaterial3: true,
  colorScheme: ColorScheme.light(
    surface: HexColor("EDF2FB"),
    primary: HexColor("ABC4FF"),
    secondary: HexColor("B6CCFE"),
    inversePrimary: Colors.black87,
  ),
);
