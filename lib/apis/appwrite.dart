import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'dart:developer';
import 'package:ai_chat_bot/config/config.dart';

class Appwrite {
  static final _client = Client();
  static final _database = Databases(_client);
  // ignore: non_constant_identifier_names
  static String db_id = '';

  static void init(dbId) {
    db_id = dbId;
    _client
      .setEndpoint("https://cloud.appwrite.io/v1")
      .setProject(env['project_id'] ?? '')
      .setSelfSigned(status: true);
  }

  static Future getItems(collectionId) async {
  print("dbid $db_id");
  print("collectionId $collectionId");
  var item = await _database.listDocuments(
    databaseId: db_id,
    collectionId: collectionId,
  );

  return item.documents.map((doc) {
    Map<String, dynamic> fixedData = doc.data.map((key, value) {
      if (value is List) {
        return MapEntry(key, value.map((e) => e.toString()).toList()); // Ensure lists are List<String>
      }
      return MapEntry(key, value);
    });

    return Document.fromMap(fixedData);
  }).toList();
}


  static Future<String> getApiKey(keyName) async {
    try {
      final d = await _database.getDocument(
      databaseId: db_id,
      collectionId: "apiKeys",
      documentId: keyName,
      );
      String apiKey = d.data['apiKey'];
      log(apiKey);
      return apiKey;
    } catch (e) {
      log('$e');
      return '';
    }
  } 

  static Future<void> addMessage(collectionId, data) async {
    await _database.createDocument(
      databaseId: db_id,
      collectionId: collectionId,
      documentId: ID.unique(),
      data: data,
    );
  }
}