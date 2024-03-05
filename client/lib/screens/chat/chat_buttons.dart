import 'dart:io';

import 'package:client/data/chat_buttons.dart';
import 'package:client/utilities/image/crop_image.dart';
import 'package:client/utilities/image/image_to_text.dart';
import 'package:client/screens/chat/display_chat_button.dart';
import 'package:client/screens/main/show_scanned_text/after_scan_sheet.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatButtons extends StatefulWidget {
  const ChatButtons(this.sendMessage, this.userMessageController, {super.key});
  final void Function(String) sendMessage;
  final TextEditingController userMessageController;

  @override
  State<ChatButtons> createState() => _ChatButtonsState();
}

class _ChatButtonsState extends State<ChatButtons> {
  late void Function(String) sendMessage;
  @override
  void initState() {
    sendMessage = widget.sendMessage;
    super.initState();
  }

  void showText(text) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => AfterScanSheet(text),
    );
  }

  void moderateTextLength(String text) {
    if (widget.userMessageController.text.length + text.length > 500) {
      widget.userMessageController.text = text.substring(1, 501);
    } else {
      widget.userMessageController.text = text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: chatButtons.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return GestureDetector(
            onTap: () async {
              try {
                final returnedImage =
                    await ImagePicker().pickImage(source: ImageSource.gallery);

                if (returnedImage != null) {
                  cropImage(returnedImage.path, context).then(
                    (path) => imageToText(File(path!))
                        .then((text) => moderateTextLength(text)),
                  );
                }
              } catch (error) {
                print(error);
              }
            },
            child: Container(
              height: 75,
              width: 75,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(255, 52, 53, 54),
              ),
              child: const Center(
                child: Icon(
                  Icons.photo,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          );
        } else {
          final chatButtonIndex = index - 1;
          return Row(
            children: [
              DisplayChatButton(sendMessage, chatButtons[chatButtonIndex]),
              const SizedBox(width: 10),
            ],
          );
        }
      },
    );
  }
}
