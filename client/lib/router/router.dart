import 'package:client/screens/chat/chat.dart';
import 'package:client/screens/edit_chat_buttons/edit_chat_buttons.dart';
import 'package:client/screens/main.dart';
import 'package:client/screens/main/home.dart';
import 'package:client/screens/main/settings.dart';
import 'package:client/screens/sign_in.dart';

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
