import 'package:client/types/chat_button_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<ChatButton> defaultButtons = [
  ChatButton(displayText: "Summarize", buttonText: "Summarize"),
  ChatButton(
      displayText:
          "Make me a quiz! Give me questions and I'll provide you with my answers.",
      buttonText: "Quiz"),
  ChatButton(
      displayText: "What language is this?", buttonText: "Analyze language"),
];

List<ChatButton> chatButtons = [];

void getChatButtons() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? resultString = prefs.getString('chatButtons');

  if (resultString != null) {
    chatButtons = ChatButton.decode(resultString);
  } else {
    chatButtons = defaultButtons;
  }
}

void _setChatButtons() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('chatButtons', ChatButton.encode(chatButtons));
}

void addChatButton(String displayText, String buttonText) {
  final ChatButton newChatButton =
      ChatButton(displayText: displayText, buttonText: buttonText);

  chatButtons.add(newChatButton);
  _setChatButtons();
}

void editChatButton(
    String displayText, String buttonText, ChatButton currentChatButton) {
  Iterable<ChatButton> editingChatButton =
      chatButtons.where((button) => button == currentChatButton);

  editingChatButton.first.buttonText = buttonText;
  editingChatButton.first.displayText = displayText;

  _setChatButtons();
}

void duplicateChatButton(ChatButton currentChatButton) {
  chatButtons.add(currentChatButton);

  _setChatButtons();
}

void deleteChatButton(ChatButton currentChatButton) {
  chatButtons.remove(currentChatButton);

  _setChatButtons();
}
