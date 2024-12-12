import 'package:save_receipt/data/database/daos/data_access_object.dart';
import 'package:save_receipt/data/models/entities/info.dart';
import 'package:save_receipt/data/database/structure/names.dart';

class InfoDao extends Dao<InfoData> {
  final String nameColumn = 'name';
  final String valueColumn = 'value';
  final String receiptIdColumn = 'receipt_id';

  @override
  Map<String, dynamic> toMap(InfoData object) {
    var map =  {
      nameColumn: object.name,
      valueColumn: object.value,
      receiptIdColumn: object.receiptId,
    };
    if (object.id != null) {
      map['id'] = object.id!;
    }
    return map;
  }

  @override
  String get createTableQuery => '''
      CREATE TABLE ${DatabaseTableNames.info}(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        $nameColumn TEXT NOT NULL,
        $valueColumn TEXT,
        $receiptIdColumn INTEGER NOT NULL,
        FOREIGN KEY ($receiptIdColumn) REFERENCES ${DatabaseTableNames.receipts} (id) ON DELETE CASCADE
      )
    ''';

  @override
  InfoData fromMap(Map<String, dynamic> query) {
    return InfoData(
        id: query['id'],
        name: query[nameColumn] ?? '<invalid_name>',
        value: query[valueColumn] ?? 0,
        receiptId: query[receiptIdColumn] ?? -1);
  }
}
