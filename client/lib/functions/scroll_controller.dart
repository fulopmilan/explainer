import 'package:flutter/material.dart';

void scrollToBottom(ScrollController scrollController, BuildContext context) {
  final screenHeight = scrollController.position.viewportDimension;
  final maxScroll = scrollController.position.maxScrollExtent;

  final targetScroll =
      maxScroll + screenHeight + MediaQuery.of(context).padding.bottom;

  scrollController.animateTo(
    targetScroll,
    curve: Curves.easeOutQuint,
    duration: const Duration(milliseconds: 1000),
  );
}
