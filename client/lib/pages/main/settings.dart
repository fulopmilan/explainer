import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:client/config/router.dart';
import 'package:google_fonts/google_fonts.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: GoogleFonts.montserrat(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 375,
              height: 75,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 52, 53, 54),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: TextButton(
                onPressed: () {
                  router.push("/edit-chat-buttons");
                },
                child: const Text(
                  "Edit chat buttons",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 48.0),
              child: Container(
                width: 200,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 52, 53, 54),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    router.go("/sign-in");
                  },
                  child: const Text(
                    "Sign out",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
