import 'package:flutter/material.dart';

class ChatTextField extends StatefulWidget {
  const ChatTextField(this.sendMessage, this.userMessageController,
      {super.key});
  final void Function(String) sendMessage;
  final TextEditingController userMessageController;

  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  late void Function(String) sendMessage;
  late TextEditingController _userMessageController;
  @override
  void initState() {
    sendMessage = widget.sendMessage;
    _userMessageController = widget.userMessageController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 52, 53, 54),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: TextField(
        maxLines: null,
        controller: _userMessageController,
        onSubmitted: (text) {
          if (_userMessageController.text.isNotEmpty) {
            sendMessage(_userMessageController.text);
            _userMessageController.clear();
          }
        },
        maxLength: 500,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Type your questions here...",
          counterStyle: const TextStyle(
            color: Colors.white,
          ),
          hintStyle: TextStyle(color: Colors.grey[400]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          suffixIcon: IconButton(
            onPressed: () {
              if (_userMessageController.text.isNotEmpty) {
                sendMessage(_userMessageController.text);
                _userMessageController.clear();
                FocusManager.instance.primaryFocus?.unfocus();
              }
            },
            icon: const Icon(Icons.send, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
