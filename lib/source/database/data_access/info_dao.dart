import 'package:save_receipt/source/database/data_access/data_access_object.dart';
import 'package:save_receipt/source/database/models/info.dart';
import 'package:save_receipt/source/database/structure/names.dart';

class InfoDao extends Dao<InfoData> {
  @override
  Map<String, dynamic> toMap(InfoData object) {
    return {
      'id': object.id,
      'name': object.name,
      'value': object.value,
      'receipt_id': object.receiptId,
    };
  }

  @override
  String get createTableQuery => '''
      CREATE TABLE ${DatabaseTableNames.info}(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        receipt_id INTEGER,
        name TEXT,
        value TEXT,
        FOREIGN KEY (receipt_id) REFERENCES receipts (id) ON DELETE CASCADE
      )
    ''';

  @override
  InfoData fromMap(Map<String, dynamic> query) {
    return InfoData(
        id: query['id'],
        name: query['name'] ?? '<invalid_name>',
        value: query['value'] ?? 0,
        receiptId: query['receipt_id'] ?? -1);
  }
}
