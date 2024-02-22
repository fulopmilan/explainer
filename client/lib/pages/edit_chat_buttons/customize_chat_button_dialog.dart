import 'package:client/data/chat_buttons.dart';
import 'package:client/types/chat_button_type.dart';
import 'package:flutter/material.dart';

class CustomizeChatButtonDialog extends StatelessWidget {
  const CustomizeChatButtonDialog(this.refreshWidget,
      {super.key, this.currentChatButton});
  final ChatButton? currentChatButton;
  final Function() refreshWidget;

  @override
  Widget build(BuildContext context) {
    final TextEditingController buttonTextController =
        TextEditingController(text: currentChatButton?.buttonText ?? "");
    final TextEditingController displayTextController =
        TextEditingController(text: currentChatButton?.displayText ?? "");

    return AlertDialog(
      title: Text(currentChatButton == null ? "Create Button" : "Edit Button"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: buttonTextController,
            decoration: const InputDecoration(
              hintText: "Enter Button Text",
              label: Text("Button text"),
            ),
          ),
          TextField(
            controller: displayTextController,
            decoration: const InputDecoration(
              hintText: "Enter Display Text",
              label: Text("Display text"),
            ),
            maxLength: 500,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (currentChatButton != null) {
              editChatButton(
                displayTextController.text,
                buttonTextController.text,
                currentChatButton!,
              );
            } else {
              addChatButton(
                displayTextController.text,
                buttonTextController.text,
              );
            }

            refreshWidget();

            Navigator.pop(context);
          },
          child: const Text("Apply"),
        ),
      ],
    );
  }
}
