import 'package:client/router/router.dart';
import 'package:client/screens/chat_history.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Main extends StatelessWidget {
  const Main(this.child, {super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideNavigationBar(),
      appBar: AppBar(
        title: Text(
          "Explainer",
          style: GoogleFonts.montserrat(),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              router.push('/settings');
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: child,
    );
  }
}
