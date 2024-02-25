import 'package:client/config/router.dart';
import 'package:client/data/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatEntry {
  final String entryName;
  final String entryId;

  ChatEntry({required this.entryName, required this.entryId});

  factory ChatEntry.fromJson(Map<String, dynamic> json) {
    return ChatEntry(
      entryName: json['entryName'],
      entryId: json['entryId'],
    );
  }
}

class SideNavigationBar extends StatefulWidget {
  const SideNavigationBar({super.key});

  @override
  State<SideNavigationBar> createState() => _SideNavigationBarState();
}

enum SideNavigationBarStates { loading, notFound, found }

class _SideNavigationBarState extends State<SideNavigationBar> {
  SideNavigationBarStates currentState = SideNavigationBarStates.loading;
  List<ChatEntry> chatEntries = [];

  @override
  void initState() {
    super.initState();
    findEntryIDsByEmail();
  }

  void findEntryIDsByEmail() async {
    CollectionReference userEntryList =
        FirebaseFirestore.instance.collection('UserEntryList');

    QuerySnapshot querySnapshot = await userEntryList
        .where('email', isEqualTo: currentUser!.email!)
        .get();

    if (querySnapshot.size == 0) {
      setState(() {
        currentState = SideNavigationBarStates.notFound;
      });
    }

    if (querySnapshot.docs.isNotEmpty) {
      var data = Map<String, dynamic>.from(querySnapshot.docs[0].data() as Map);
      setState(() {
        List<dynamic> entriesJson = data["entries"];
        chatEntries = entriesJson
            .map((entryJson) => ChatEntry.fromJson(entryJson))
            .toList();
        currentState = SideNavigationBarStates.found;
        if (entriesJson.isEmpty) {
          currentState = SideNavigationBarStates.notFound;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: currentState == SideNavigationBarStates.found
          ? Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 8,
              ),
              child: ListView.builder(
                reverse: true,
                itemCount: chatEntries.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      router.push(
                        '/chat/${chatEntries[index].entryId}/${Uri.encodeComponent(chatEntries[index].entryName)}',
                      );
                      Navigator.pop(context);
                    },
                    child: SizedBox(
                      height: 65,
                      child: Card(
                        color: const Color.fromARGB(255, 52, 53, 54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              chatEntries[index].entryName,
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          : currentState == SideNavigationBarStates.notFound
              ? Center(
                  child: Text(
                    "No entries found",
                    style: GoogleFonts.montserrat(),
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
    );
  }
}
