import 'package:client/data/chat_buttons.dart';
import 'package:client/screens/edit_chat_buttons/customize_chat_button_dialog.dart';
import 'package:client/data/enums/chat_button_type.dart';
import 'package:flutter/material.dart';

class ChatButtonItem extends StatefulWidget {
  const ChatButtonItem(this.currentChatButton, this.refreshListWidget,
      {super.key});
  final ChatButton currentChatButton;
  final Function() refreshListWidget;

  @override
  State<ChatButtonItem> createState() => _ChatButtonItemState();
}

class _ChatButtonItemState extends State<ChatButtonItem> {
  void refreshWidget() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final refreshListWidget = widget.refreshListWidget;
    ChatButton currentChatButton = widget.currentChatButton;

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) {
            return CustomizeChatButtonDialog(
              refreshWidget,
              currentChatButton: currentChatButton,
            );
          },
        );
      },
      onLongPress: () {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (_) {
                          return CustomizeChatButtonDialog(
                            refreshWidget,
                            currentChatButton: currentChatButton,
                          );
                        },
                      );
                    },
                    child: const Text("Edit"),
                  ),
                  TextButton(
                    onPressed: () {
                      duplicateChatButton(currentChatButton);
                      refreshListWidget();
                      Navigator.of(context).pop();
                    },
                    child: const Text("Duplicate"),
                  ),
                  TextButton(
                    onPressed: () {
                      deleteChatButton(currentChatButton);
                      refreshListWidget();
                      Navigator.of(context).pop();
                    },
                    child: const Text("Delete"),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: SizedBox(
        height: 100,
        width: double.infinity,
        child: Container(
          width: 375,
          height: 75,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 52, 53, 54),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Center(
            child: Text(
              currentChatButton.buttonText,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
