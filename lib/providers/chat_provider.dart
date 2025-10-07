import 'dart:async';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/message.dart';
import '../models/chat.dart';
import '../services/firebase_service.dart';
import '../services/gemini_service.dart';

class ChatProvider with ChangeNotifier {
  final FirebaseService _firebaseService;
  final GeminiService _geminiService;

  Chat? _currentChat;
  List<Chat> _chats = [];
  List<Message> _messages = [];
  bool _isLoading = false;
  String? _error;
  String? _userId;

  StreamSubscription<List<Chat>>? _chatsSubscription;
  StreamSubscription<List<Message>>? _messagesSubscription;

  ChatProvider(this._firebaseService, this._geminiService);

  // Getters
  Chat? get currentChat => _currentChat;
  List<Chat> get chats => _chats;
  List<Message> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get userId => _userId;

  bool get isAuthenticated => _userId != null;

  void setUser(String? userId) {
    if (_userId == userId) return;

    _userId = userId;
    _clearSubscriptions();
    _currentChat = null;
    _messages = [];
    _chats = [];
    _error = null;
    _geminiService.resetChat();
    notifyListeners();

    if (_userId != null) {
      _observeChats();
    }
  }

  // Load all chats
  void _observeChats() {
    if (_userId == null) return;

    _chatsSubscription?.cancel();
    _chatsSubscription = _firebaseService.getChats(_userId!).listen((chats) {
      _chats = chats;
      notifyListeners();

      final hasCurrentChat =
          _currentChat != null &&
          chats.any((chat) => chat.id == _currentChat!.id);

      if (!hasCurrentChat && chats.isNotEmpty) {
        _currentChat = null;
        _messages = [];
        unawaited(selectChat(chats.first));
        return;
      }

      if (!hasCurrentChat && chats.isEmpty) {
        _currentChat = null;
        _messages = [];
        _messagesSubscription?.cancel();
        _messagesSubscription = null;
        notifyListeners();
        return;
      }

      if (_currentChat == null && chats.isNotEmpty) {
        unawaited(selectChat(chats.first));
      }
    });
  }

  void _clearSubscriptions() {
    _chatsSubscription?.cancel();
    _chatsSubscription = null;
    _messagesSubscription?.cancel();
    _messagesSubscription = null;
  }

  void _subscribeToMessages(String chatId) {
    if (_userId == null) return;

    _messagesSubscription?.cancel();
    _messagesSubscription = _firebaseService
        .getMessages(userId: _userId!, chatId: chatId)
        .listen((remoteMessages) {
          _mergeRemoteMessages(remoteMessages);
        });
  }

  void _mergeRemoteMessages(List<Message> remoteMessages) {
    if (remoteMessages.isEmpty && _messages.isEmpty) {
      notifyListeners();
      return;
    }

    final remoteMap = {
      for (final message in remoteMessages) message.id: message,
    };

    final pendingLocals = _messages
        .where((message) => !remoteMap.containsKey(message.id))
        .toList();

    _messages = [...remoteMessages, ...pendingLocals]
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    notifyListeners();
  }

  // Create a new chat
  Future<void> createNewChat() async {
    if (_userId == null) {
      _error = 'Please sign in to create a chat.';
      notifyListeners();
      return;
    }

    try {
      _error = null;
      final chat = await _firebaseService.createChat(
        userId: _userId!,
        title: 'New Chat',
      );
      _currentChat = chat;
      _messages = [];
      _geminiService.resetChat();

      // Cancel old subscription and set up listener for messages in the new chat
      _subscribeToMessages(chat.id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Select a chat
  Future<void> selectChat(Chat chat) async {
    if (_userId == null) return;

    _currentChat = chat;
    _messages = [];
    _geminiService.resetChat();
    _subscribeToMessages(chat.id);
    notifyListeners();
  }

  // Send a message
  Future<void> sendMessage(String text) async {
    if (_userId == null) {
      _error = 'You must be signed in to send messages.';
      notifyListeners();
      return;
    }

    if (_currentChat == null) {
      await createNewChat();
    }

    if (text.trim().isEmpty) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final chat = _currentChat;
      if (chat == null) {
        throw Exception('Unable to create chat');
      }

      // Create user message
      final userMessage = Message(
        id: const Uuid().v4(),
        text: text.trim(),
        isUser: true,
        timestamp: DateTime.now(),
        chatId: chat.id,
      );

      // Add user message to UI immediately
      _messages.add(userMessage);
      notifyListeners();

      // Update chat title if this is the first message
      if (_messages.length == 1) {
        final title = text.length > 30 ? '${text.substring(0, 30)}...' : text;
        _firebaseService.updateChatTitle(
          userId: _userId!,
          chatId: chat.id,
          title: title,
        );
      }

      // Save user message to Firebase in background
      unawaited(
        _firebaseService.addMessage(userId: _userId!, message: userMessage),
      );

      // Prepare AI message placeholder
      final aiMessageId = const Uuid().v4();
      final aiMessage = Message(
        id: aiMessageId,
        text: '',
        isUser: false,
        timestamp: DateTime.now(),
        chatId: chat.id,
      );

      _messages.add(aiMessage);
      notifyListeners();

      // Get full AI response once and update the placeholder
      var aiResponse = await _geminiService.sendMessage(text.trim());
      if (aiResponse.trim().isEmpty) {
        aiResponse = 'I wasn\'t able to generate a response.';
      }

      final aiIndex = _messages.indexWhere((m) => m.id == aiMessageId);
      if (aiIndex != -1) {
        _messages[aiIndex] = _messages[aiIndex].copyWith(text: aiResponse);
      }
      notifyListeners();

      // Save AI message to Firebase
      unawaited(
        _firebaseService.addMessage(
          userId: _userId!,
          message: _messages.firstWhere((m) => m.id == aiMessageId),
        ),
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to send message: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete a chat
  Future<void> deleteChat(String chatId) async {
    if (_userId == null) return;
    try {
      await _firebaseService.deleteChat(userId: _userId!, chatId: chatId);
      if (_currentChat?.id == chatId) {
        _currentChat = null;
        _messages = [];
        _messagesSubscription?.cancel();
        _messagesSubscription = null;
      }
      notifyListeners();
    } catch (e) {
      _error = 'Failed to delete chat: $e';
      notifyListeners();
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _chatsSubscription?.cancel();
    _messagesSubscription?.cancel();
    super.dispose();
  }
}
