import 'package:flutter/material.dart';

final ThemeData defaultTheme = ThemeData(
    primaryColor: const Color(0xFF5521B5),
    primarySwatch: const MaterialColor(
      0xFF5521B5,
      <int, Color>{
        50: Color(0x1A5521B5), //10%
        100: Color(0x335521B5), //20%
        200: Color(0x4c5521B5), //30%
        300: Color(0x665521B5), //40%
        400: Color(0x805521B5), //50%
        500: Color(0x995521B5), //60%
        600: Color(0xB35521B5), //70%
        700: Color(0xCC5521B5), //80%
        800: Color(0xE65521B5), //90%
        900: Color(0xff5521B5), //100%
      }
    ),
    appBarTheme: const AppBarTheme(color: Color(0xFF5521B5)),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5521B5))));
