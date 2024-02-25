import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light().copyWith(
    background: const Color.fromARGB(255, 255, 255, 255),
    primary: const Color.fromARGB(255, 28, 28, 28),
  ),
);
