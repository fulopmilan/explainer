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
    if (newEntryName.isEmpty) {
      newEntryName = "Unnamed";
    }

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
    final Color dialogBackgroundColor =
        Theme.of(context).colorScheme.background;
    final Color textColor = Theme.of(context).colorScheme.primary;
    final Color buttonColor = Theme.of(context).colorScheme.primary;

    Widget chatRenameDialog(BuildContext ctx) {
      TextEditingController renameController = TextEditingController();
      return Dialog(
        backgroundColor: dialogBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: renameController,
                decoration: InputDecoration(
                  label: const Text("New entry name"),
                  hintStyle: TextStyle(color: textColor),
                  border: const OutlineInputBorder(),
                ),
                style: TextStyle(color: textColor),
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                width: 300,
                child: ElevatedButton(
                  onPressed: () {
                    modifyEntryNameByEntryId(renameController.text);
                    Navigator.pop(context);
                    Navigator.pop(ctx);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    "Apply",
                    style: TextStyle(color: dialogBackgroundColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget settingsDialog = Dialog(
      backgroundColor: dialogBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 300,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) {
                      return chatRenameDialog(ctx);
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  "Edit name",
                  style: TextStyle(color: dialogBackgroundColor),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              width: 300,
              child: ElevatedButton(
                onPressed: () {
                  deleteEntryByEntryId();
                  router.go('/home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  "Delete entry",
                  style: TextStyle(color: dialogBackgroundColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) {
                  return settingsDialog;
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
