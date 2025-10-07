import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/chat_provider.dart';
import 'chat_screen.dart';
import 'sign_in_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  User? _lastUser;

  void _syncUserWithProvider(User? user) {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ChatProvider>().setUser(user?.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User?>();

    if (_lastUser?.uid != user?.uid) {
      _lastUser = user;
      _syncUserWithProvider(user);
    }

    if (user == null) {
      return const SignInScreen();
    }

    return const ChatScreen();
  }
}
