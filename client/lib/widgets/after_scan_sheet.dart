import 'package:client/config/router.dart';
import 'package:client/data/user.dart';
import 'package:client/functions/add_or_update_user_entry.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class AfterScanSheet extends StatefulWidget {
  const AfterScanSheet(this.text, {Key? key}) : super(key: key);
  final String text;

  @override
  State<AfterScanSheet> createState() => _AfterScanSheetState();
}

class _AfterScanSheetState extends State<AfterScanSheet> {
  final TextEditingController _scannedTextController = TextEditingController();
  late String text = "";

  @override
  void initState() {
    if (text.length > 2000) {
      text = widget.text.substring(1, 2001);
    } else {
      text = widget.text;
    }
    _scannedTextController.text = text;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var randomId = uuid.v1(); //generates a random ID based on time
    var entryName = text.length > 35
        ? "${_scannedTextController.text.substring(0, 35).trim().replaceAll("\n", " ")}..."
        : _scannedTextController.text.trim().replaceAll("\n", " ");
    return Container(
      constraints: const BoxConstraints.expand(),
      child: text.isNotEmpty
          ? ListView(
              shrinkWrap: true,
              children: [
                const SizedBox(
                  height: 25,
                ),
                Center(
                  child: Text(
                    "Scanned text",
                    style: GoogleFonts.montserrat(
                      fontSize: 24,
                    ),
                  ),
                ),
                SizedBox(
                  height: 300,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 32,
                    ),
                    child: Center(
                      child: TextField(
                        maxLines: null,
                        controller: _scannedTextController,
                        maxLength: 2000,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 52, 53, 54),
                        ),
                        decoration: InputDecoration(
                          hintText: "Type anything here...",
                          counterStyle: const TextStyle(
                            color: Colors.white,
                          ),
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 5.0,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: Center(
                    child: Container(
                      width: 150,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 35, 35, 36),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: TextButton(
                        onPressed: () {
                          addOrUpdateUserEntry(
                            currentUser!.email!,
                            randomId, //generates a random ID based on time
                            entryName,
                            _scannedTextController.text,
                          ).then(
                            (value) {
                              Navigator.pop(context);
                              router.push('/chat/$randomId/$entryName');
                            },
                          );
                        },
                        child: const Text(
                          "Ask questions!",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Center(
              child: Text(
                "No text scanned",
                style: GoogleFonts.montserrat(),
              ),
            ),
    );
  }
}
