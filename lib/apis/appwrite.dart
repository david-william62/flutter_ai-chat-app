import 'package:appwrite/appwrite.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:developer';


class Appwrite {
  static final _client = Client();
  static final _database = Databases(_client);

  static void init() {
    _client
      .setEndpoint("https://cloud.appwrite.io/v1")
      .setProject(dotenv.env['project_id'])
      .setSelfSigned(status: true);
  }

  static Future<List> getItems(collectionId) async {
    final item = await _database.listDocuments(
      databaseId: "MyDB",
      collectionId: collectionId,
    );
    return item.documents;
  }

  static Future<String> getApiKey(keyName) async {
    try {
      final d = await _database.getDocument(
      databaseId: "MyDB",
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
}