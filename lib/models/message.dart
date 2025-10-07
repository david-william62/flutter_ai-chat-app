import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String chatId;

  Message({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    required this.chatId,
  });

  // Convert Message to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'isUser': isUser,
      'timestamp': Timestamp.fromDate(timestamp),
      'chatId': chatId,
    };
  }

  // Create Message from Firestore document
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      isUser: map['isUser'] ?? false,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      chatId: map['chatId'] ?? '',
    );
  }

  Message copyWith({
    String? id,
    String? text,
    bool? isUser,
    DateTime? timestamp,
    String? chatId,
  }) {
    return Message(
      id: id ?? this.id,
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      chatId: chatId ?? this.chatId,
    );
  }
}
