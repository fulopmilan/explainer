import 'package:client/functions/scroll_controller.dart';
import 'package:client/widgets/expandable_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatMessages extends StatefulWidget {
  const ChatMessages(this.chatHistory, this.scrollController, {Key? key})
      : super(key: key);
  final List<dynamic> chatHistory;
  final ScrollController scrollController;

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  late List<dynamic> chatHistory;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (widget.scrollController.position.maxScrollExtent -
            widget.scrollController.position.pixels >
        500) {
      setState(() {
        _isVisible = true;
      });
    } else {
      setState(() {
        _isVisible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    chatHistory = widget.chatHistory;

    return Expanded(
      child: Stack(
        children: [
          ListView.builder(
            controller: widget.scrollController,
            itemCount: chatHistory.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: index == 0
                      ? [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Topic",
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                color: const Color.fromARGB(255, 139, 139, 139),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: ExpandableWidget(
                              Text(
                                chatHistory[index],
                                textAlign: TextAlign.left,
                                style: GoogleFonts.sourceSans3(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ]
                      : [
                          Align(
                            alignment: index % 2 == 0
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            child: Text(
                              index % 2 == 0 ? "Robot" : "User",
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                color: const Color.fromARGB(255, 139, 139, 139),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Align(
                            alignment: index % 2 == 0
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            child: Text(
                              chatHistory[index],
                              textAlign: index % 2 == 0
                                  ? TextAlign.left
                                  : TextAlign.right,
                              style: GoogleFonts.sourceSans3(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Visibility(
                visible: _isVisible,
                child: FloatingActionButton(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    ),
                  ),
                  onPressed: () {
                    scrollToBottom(widget.scrollController, context);
                  },
                  backgroundColor: const Color.fromARGB(255, 52, 53, 54),
                  child: Icon(
                    Icons.arrow_downward,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
