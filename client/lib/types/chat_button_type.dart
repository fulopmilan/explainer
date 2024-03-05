import 'dart:convert';

class ChatButton {
  //requestText is the text that is sent to the server, displayText appears in the chatbox, buttonText is on the button
  late String contentText, buttonText;

  ChatButton({required this.contentText, required this.buttonText});

  factory ChatButton.fromJson(Map<String, dynamic> jsonData) {
    return ChatButton(
      contentText: jsonData['contentText'],
      buttonText: jsonData['buttonText'],
    );
  }

  static Map<String, dynamic> toMap(ChatButton chatButton) => {
        'contentText': chatButton.contentText,
        'buttonText': chatButton.buttonText,
      };

  static String encode(List<ChatButton> buttons) => json.encode(
        buttons
            .map<Map<String, dynamic>>((button) => ChatButton.toMap(button))
            .toList(),
      );

  static List<ChatButton> decode(String buttons) =>
      (json.decode(buttons) as List<dynamic>)
          .map<ChatButton>((item) => ChatButton.fromJson(item))
          .toList();
}
