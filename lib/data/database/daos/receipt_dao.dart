import 'package:save_receipt/data/database/daos/data_access_object.dart';
import 'package:save_receipt/data/models/entities/receipt.dart';
import 'package:save_receipt/data/database/structure/names.dart';

class ReceiptDao extends Dao<ReceiptData> {
  final String shopIdColumnt = 'shop_id';
  final String timeColumn = 'time';
  final String totalCostColumn = 'total_cost';
  final String imgPathColumn = 'img_path';
  final String titleColumn = 'title';

  @override
  Map<String, dynamic> toMap(ReceiptData object) {
    var map = {
      titleColumn: object.title,
      shopIdColumnt: object.shopId,
      timeColumn: object.time,
      totalCostColumn: object.totalCost,
      imgPathColumn: object.imgPath,
    };
    if (object.id != null) {
      map['id'] = object.id;
    }
    return map;
  }

  @override
  String get createTableQuery => '''
      CREATE TABLE ${DatabaseTableNames.receipts}(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        $shopIdColumnt INTEGER DEFAULT -1,
        $titleColumn TEXT NOT NULL,
        $timeColumn TEXT NOT NULL,
        $totalCostColumn REAL NOT NULL,
        $imgPathColumn TEXT,
        FOREIGN KEY ($shopIdColumnt) REFERENCES ${DatabaseTableNames.shops} (id) ON DELETE SET DEFAULT
      )
    ''';

  @override
  ReceiptData fromMap(Map<String, dynamic> query) {
    return ReceiptData(
      id: query['id'],
      title: query[titleColumn],
      shopId: query[shopIdColumnt],
      time: query[timeColumn],
      totalCost: (query[totalCostColumn] ?? 0.0) as double,
      imgPath: query[imgPathColumn],
    );
  }
}
