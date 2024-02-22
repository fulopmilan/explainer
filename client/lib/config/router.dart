import 'package:client/pages/chat/chat.dart';
import 'package:client/pages/edit_chat_buttons/edit_chat_buttons.dart';
import 'package:client/pages/main.dart';
import 'package:client/pages/main/home.dart';
import 'package:client/pages/main/settings.dart';
import 'package:client/pages/sign_in.dart';

import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/sign-in',
  routes: [
    ShellRoute(
      builder: (context, state, child) => Main(child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const Home(),
        ),
      ],
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const Settings(),
    ),
    GoRoute(
      path: '/edit-chat-buttons',
      builder: (context, state) => const EditChatButtons(),
    ),
    GoRoute(
      path: '/chat/:entryId/:entryName',
      builder: (context, state) {
        final String entryId = state.pathParameters['entryId']!;
        final String entryName = state.pathParameters['entryName']!;
        return Chat(entryId, entryName);
      },
    ),
    GoRoute(
      path: '/sign-in',
      builder: (context, state) => const SignIn(),
    ),
  ],
);
