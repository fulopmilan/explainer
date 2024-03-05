import 'package:flutter/material.dart';
import 'package:client/data/chat_buttons.dart';
import 'package:client/data/enums/chat_button_type.dart';

class CustomizeChatButtonDialog extends StatelessWidget {
  const CustomizeChatButtonDialog(this.refreshWidget,
      {Key? key, this.currentChatButton})
      : super(key: key);

  final ChatButton? currentChatButton;
  final Function() refreshWidget;

  @override
  Widget build(BuildContext context) {
    final Color dialogBackgroundColor =
        Theme.of(context).colorScheme.background;
    final Color textColor = Theme.of(context).colorScheme.primary;
    final Color buttonColor = Theme.of(context).colorScheme.primary;

    final TextEditingController buttonTextController =
        TextEditingController(text: currentChatButton?.buttonText ?? "");
    final TextEditingController displayTextController =
        TextEditingController(text: currentChatButton?.contentText ?? "");

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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              currentChatButton == null ? "Create Button" : "Edit Button",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: buttonTextController,
              decoration: InputDecoration(
                labelText: "Button Text",
                border: const OutlineInputBorder(),
                labelStyle: TextStyle(color: textColor),
              ),
              style: TextStyle(color: textColor),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter button text';
                }
                return null;
              },
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: displayTextController,
              decoration: InputDecoration(
                labelText: "Display Text",
                border: const OutlineInputBorder(),
                labelStyle: TextStyle(color: textColor),
              ),
              style: TextStyle(color: textColor),
              maxLines: 3,
              maxLength: 500,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter display text';
                }
                return null;
              },
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
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
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                backgroundColor: buttonColor,
              ),
              child: Text(
                "Apply",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Theme.of(context).colorScheme.background,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
