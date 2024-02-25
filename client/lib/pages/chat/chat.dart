import 'package:client/config/router.dart';
import 'package:client/data/user.dart';
import 'package:client/pages/chat/chat_buttons.dart';
import 'package:client/pages/chat/chat_messages.dart';
import 'package:client/pages/chat/chat_textfield.dart';
import 'package:client/functions/save_chat_to_database.dart';
import 'package:client/functions/scroll_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Chat extends StatefulWidget {
  const Chat(this.entryId, this.entryName, {super.key});
  final String entryId;
  final String entryName;

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late String entryId;
  late String entryName;
  late List<dynamic> chatHistory = [];
  final ScrollController scrollController = ScrollController();
  final TextEditingController renameController = TextEditingController();
  final TextEditingController _userMessageController = TextEditingController();

  @override
  void initState() {
    super.initState();

    findChatHistoryByEntryID();
    entryId = widget.entryId;
    entryName = widget.entryName;
  }

  void findChatHistoryByEntryID() async {
    CollectionReference entryDataList =
        FirebaseFirestore.instance.collection('EntryData');

    QuerySnapshot querySnapshot =
        await entryDataList.where('entryId', isEqualTo: widget.entryId).get();

    if (querySnapshot.docs.isNotEmpty) {
      var data = Map<String, dynamic>.from(querySnapshot.docs[0].data() as Map);
      setState(() {
        chatHistory = data["chatHistory"];
      });
    } else {
      print('no document found.');
    }
  }

  void modifyEntryNameByEntryId(String newEntryName) async {
    CollectionReference userEntryList =
        FirebaseFirestore.instance.collection('UserEntryList');

    QuerySnapshot querySnapshot =
        await userEntryList.where('email', isEqualTo: currentUser!.email).get();

    final DocumentReference userDocRef = querySnapshot.docs.first.reference;

    userDocRef.update(
      {
        'entries': FieldValue.arrayRemove(
          [
            {
              'entryId': entryId,
              'entryName': entryName,
            }
          ],
        ),
      },
    );

    userDocRef.update(
      {
        'entries': FieldValue.arrayUnion(
          [
            {
              'entryId': entryId,
              'entryName': newEntryName,
            }
          ],
        ),
      },
    );

    setState(() {
      entryName = newEntryName;
    });
  }

  void deleteEntryByEntryId() async {
    CollectionReference userEntryList =
        FirebaseFirestore.instance.collection('UserEntryList');

    QuerySnapshot userQuerySnapshot =
        await userEntryList.where('email', isEqualTo: currentUser!.email).get();

    final DocumentReference userDocRef = userQuerySnapshot.docs.first.reference;

    userDocRef.update(
      {
        'entries': FieldValue.arrayRemove(
          [
            {
              'entryId': entryId,
              'entryName': entryName,
            }
          ],
        ),
      },
    );

    CollectionReference entryDataList =
        FirebaseFirestore.instance.collection('EntryData');

    QuerySnapshot entryQuerySnapshot =
        await entryDataList.where('entryId', isEqualTo: widget.entryId).get();

    final DocumentReference entryDocRef =
        entryQuerySnapshot.docs.first.reference;

    entryDocRef.delete();
  }

  List<dynamic>? _prepareSentChatHistory(String text) {
    final preChatHistory = List.from(chatHistory);
    return preChatHistory.length > 4
        ? [
            preChatHistory[0],
            preChatHistory[preChatHistory.length - 1],
            preChatHistory[preChatHistory.length - 2],
            preChatHistory[preChatHistory.length - 3],
            preChatHistory[preChatHistory.length - 4],
            text,
          ]
        : null;
  }

  // sends a message to the AI, and adds the same request into the chatHistory
  void sendMessage(String text) async {
    if (chatHistory.last != "Generating answer...") {
      setState(() {
        chatHistory.add(text);
        chatHistory.add("Generating answer...");
      });
      scrollToBottom(scrollController, context);

      final sentChatHistory = _prepareSentChatHistory(text);

      await FirebaseFunctions.instance.httpsCallable('callai').call(
        {
          "text": sentChatHistory ?? chatHistory,
          "push": true,
        },
      ).then(
        (result) => {
          setState(() {
            chatHistory.removeLast();
            chatHistory.add(result.data);

            //save to db
            saveChatToDatabase(chatHistory, entryId);
          }),
          scrollToBottom(scrollController, context)
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: renameController,
                                        decoration: const InputDecoration(
                                          hintText: "New entry name",
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        modifyEntryNameByEntryId(
                                            renameController.text);
                                        Navigator.pop(ctx);
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Apply"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Text("Edit name"),
                        ),
                        TextButton(
                          onPressed: () {
                            deleteEntryByEntryId();
                            router.go('/home');
                          },
                          child: const Text("Delete entry"),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
        title: Text(
          entryName,
          style: GoogleFonts.montserrat(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ChatMessages(chatHistory, scrollController),
            SizedBox(
              height: 50,
              child: ChatButtons(sendMessage, _userMessageController),
            ),
            const SizedBox(
              height: 10,
            ),
            ChatTextField(sendMessage, _userMessageController),
          ],
        ),
      ),
    );
  }
}
