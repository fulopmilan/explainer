import 'package:flutter/material.dart';

Widget button(Alignment alignment, IconData icon) {
  return Align(
    alignment: alignment,
    child: Container(
      margin: const EdgeInsets.only(
        left: 20,
        bottom: 20,
      ),
      height: 50,
      width: 50,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 66, 66, 66),
            blurRadius: 5.0,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          icon,
          color: const Color.fromARGB(255, 28, 28, 28),
        ),
      ),
    ),
  );
}
