import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark().copyWith(
    background: const Color.fromARGB(255, 28, 28, 28),
    primary: Colors.white,
  ),
);
