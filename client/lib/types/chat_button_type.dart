import 'dart:convert';

class ChatButton {
  //requestText is the text that is sent to the server, displayText appears in the chatbox, buttonText is on the button
  late String displayText, buttonText;

  ChatButton({required this.displayText, required this.buttonText});

  factory ChatButton.fromJson(Map<String, dynamic> jsonData) {
    return ChatButton(
      displayText: jsonData['displayText'],
      buttonText: jsonData['buttonText'],
    );
  }

  static Map<String, dynamic> toMap(ChatButton chatButton) => {
        'displayText': chatButton.displayText,
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
