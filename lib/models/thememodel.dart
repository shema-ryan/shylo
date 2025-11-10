import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  fontFamily: 'Poppins',
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xff34dd00),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(5)),
      
    )
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5)
      )
    )
  ),
  colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff34dd00))
);