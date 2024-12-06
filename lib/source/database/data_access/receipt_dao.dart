import 'package:save_receipt/source/database/data_access/data_access_object.dart';
import 'package:save_receipt/source/database/models/receipt.dart';
import 'package:save_receipt/source/database/structure/names.dart';

class ReceiptDao extends Dao<ReceiptData> {
  @override
  Map<String, dynamic> toMap(ReceiptData object) {
    return {
      'id': object.id,
      'shop_id': object.shopId,
      'date': object.date,
      'total_amount': object.totalAmount,
      'img_path': object.imgPath,
    };
  }

  @override
  String get createTableQuery => '''
      CREATE TABLE ${DatabaseTableNames.receipts}(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        shop_id INTEGER DEFAULT -1,
        date TEXT NOT NULL,
        total_amount INTEGER NOT NULL,
        img_path TEXT NOT NULL
        FOREIGN KEY (receipt_id) REFERENCES receipts (id) ON DELETE SET DEFAULT
      )
    ''';

  @override
  ReceiptData fromMap(Map<String, dynamic> query) {
    return ReceiptData(
      id: query['id'],
      shopId: query['shop_id'],
      date: query['date'],
      totalAmount: query['total_amount'],
      imgPath: query['img_path'],
    );
  }
}
