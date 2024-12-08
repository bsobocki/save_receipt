import 'package:save_receipt/data/database/daos/data_access_object.dart';
import 'package:save_receipt/data/models/receipt.dart';
import 'package:save_receipt/data/database/structure/names.dart';

class ReceiptDao extends Dao<ReceiptData> {
  final String shopIdColumnt = 'shop_id';
  final String dateColumn = 'date';
  final String totalCostColumn = 'total_cost';
  final String imgPathColumn = 'img_path';

  @override
  Map<String, dynamic> toMap(ReceiptData object) {
    return {
      'id': object.id,
      shopIdColumnt: object.shopId,
      dateColumn: object.date,
      totalCostColumn: object.totalCost,
      imgPathColumn: object.imgPath,
    };
  }

  @override
  String get createTableQuery => '''
      CREATE TABLE ${DatabaseTableNames.receipts}(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        $shopIdColumnt INTEGER DEFAULT -1,
        $dateColumn TEXT NOT NULL,
        $totalCostColumn INTEGER NOT NULL,
        $imgPathColumn TEXT,
        FOREIGN KEY (receipt_id) REFERENCES receipts (id) ON DELETE SET DEFAULT
      )
    ''';

  @override
  ReceiptData fromMap(Map<String, dynamic> query) {
    return ReceiptData(
      id: query['id'],
      shopId: query['shop_id'],
      date: query['date'],
      totalCost: query['total_amount'],
      imgPath: query['img_path'],
    );
  }
}
