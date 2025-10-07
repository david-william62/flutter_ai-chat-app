import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message.dart';
import '../models/chat.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _userChatsCollection(
    String userId,
  ) => _firestore.collection('users').doc(userId).collection('chats');

  CollectionReference<Map<String, dynamic>> _messagesCollection(
    String userId,
    String chatId,
  ) => _userChatsCollection(userId).doc(chatId).collection('messages');

  // Create a new chat for user
  Future<Chat> createChat({
    required String userId,
    required String title,
  }) async {
    final chatDoc = _userChatsCollection(userId).doc();
    final now = DateTime.now();

    final chat = Chat(
      id: chatDoc.id,
      title: title,
      createdAt: now,
      lastMessageAt: now,
    );

    await chatDoc.set(chat.toMap());
    return chat;
  }

  // Stream all chats for user
  Stream<List<Chat>> getChats(String userId) {
    return _userChatsCollection(userId)
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Chat.fromMap(doc.data())).toList(),
        );
  }

  // Stream messages for specific chat
  Stream<List<Message>> getMessages({
    required String userId,
    required String chatId,
  }) {
    return _messagesCollection(userId, chatId)
        .orderBy('timestamp')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Message.fromMap(doc.data())).toList(),
        );
  }

  // Add message to chat and update metadata
  Future<void> addMessage({
    required String userId,
    required Message message,
  }) async {
    final messages = _messagesCollection(userId, message.chatId);
    await messages.doc(message.id).set(message.toMap());

    await _userChatsCollection(userId).doc(message.chatId).update({
      'lastMessageAt': Timestamp.fromDate(message.timestamp),
    });
  }

  Future<void> updateChatTitle({
    required String userId,
    required String chatId,
    required String title,
  }) async {
    await _userChatsCollection(userId).doc(chatId).update({'title': title});
  }

  Future<void> deleteChat({
    required String userId,
    required String chatId,
  }) async {
    final chatDoc = _userChatsCollection(userId).doc(chatId);

    final messagesSnapshot = await _messagesCollection(userId, chatId).get();
    final batch = _firestore.batch();
    for (final doc in messagesSnapshot.docs) {
      batch.delete(doc.reference);
    }
    batch.delete(chatDoc);
    await batch.commit();
  }
}
