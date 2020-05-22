import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_downloader_example/post.dart';
import 'package:network_image_to_byte/network_image_to_byte.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

typedef DbOperation = Future<dynamic> Function(Database db, StoreRef collection,
    {int key, History history, bool isVideo});

class HistoryLogic with ChangeNotifier {
  Future dbOperations(DbOperation dbOperation,
      {int key, History history, bool isVideo}) async {
    var appDirectory = await getApplicationDocumentsDirectory();
    final db = await databaseFactoryIo
        .openDatabase(join(appDirectory.path, 'history'));
    var collection = intMapStoreFactory.store('history');

    var result = dbOperation(db, collection,
        key: key, history: history, isVideo: isVideo);
    await db.close();
    return result;
  }

  Future<List<RecordSnapshot>> readElements(Database db, StoreRef collection,
      {int key, History history, bool isVideo}) async {
    var result = await collection.find(db,
        finder: Finder(filter: Filter.equals('isVideo', isVideo)));

    return result;
  }

  Future readElement(Database db, StoreRef collection,
      {int key, History history, bool isVideo}) async {
    var result = await collection.record(key).get(db);
    return result;
  }

  Future<void> addElement(Database db, StoreRef collection,
      {History history, int key, bool isVideo}) async {
    await collection.add(db, history.toJson());
  }
}
