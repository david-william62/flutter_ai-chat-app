import 'package:appwrite/appwrite.dart';

class Appwrite {
  static final _client = Client();
  static final _database = Databases(_client);

  static void init() {
    _client
      .setEndpoint("https://cloud.appwrite.io/v1")
      .setProject('676cf8c60003188f03b0')
      .setSelfSigned(status: true);
  }

  static Future<List> getItems(collectionId) async {
    final item = await _database.listDocuments(
      databaseId: "MyDB",
      collectionId: collectionId,
    );
    return item.documents;
  }
}