import 'package:client/data/chat_buttons.dart';
import 'package:client/pages/edit_chat_buttons/chat_button_item.dart';
import 'package:client/pages/edit_chat_buttons/customize_chat_button_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditChatButtons extends StatefulWidget {
  const EditChatButtons({super.key});

  @override
  State<EditChatButtons> createState() => _EditChatButtonsState();
}

class _EditChatButtonsState extends State<EditChatButtons> {
  void refreshListWidget() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Chat Buttons",
          style: GoogleFonts.montserrat(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 52, 53, 54),
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) {
              return CustomizeChatButtonDialog(
                refreshListWidget,
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.builder(
          itemCount: chatButtons.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ChatButtonItem(
                  chatButtons[index],
                  refreshListWidget,
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
