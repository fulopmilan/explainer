import 'package:client/types/chat_button_type.dart';
import 'package:flutter/material.dart';

class DisplayChatButton extends StatelessWidget {
  const DisplayChatButton(this.sendMessage, this.chatButtonData, {super.key});
  final void Function(String) sendMessage;
  final ChatButton chatButtonData;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 52, 53, 54),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: TextButton(
        onPressed: () {
          sendMessage(chatButtonData.contentText);
        },
        child: Text(
          chatButtonData.buttonText,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
