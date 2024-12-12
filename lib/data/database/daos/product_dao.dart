import 'package:save_receipt/data/database/daos/data_access_object.dart';
import 'package:save_receipt/data/models/entities/product.dart';
import 'package:save_receipt/data/database/structure/names.dart';

class ProductDao extends Dao<ProductData> {
  final String nameColumn = 'name';
  final String priceColumn = 'price';
  final String receiptIdColumn = 'receipt_id';

  @override
  Map<String, dynamic> toMap(ProductData object) {
    var map = {
      nameColumn: object.name,
      priceColumn: object.price,
      receiptIdColumn: object.receiptId,
    };
    if (object.id != null) {
      map['id'] = object.id!;
    }
    return map;
  }

  @override
  String get createTableQuery => '''
      CREATE TABLE ${DatabaseTableNames.products}(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        $nameColumn TEXT NOT NULL,
        $priceColumn REAL NOT NULL,
        $receiptIdColumn INTEGER NOT NULL,
        FOREIGN KEY ($receiptIdColumn) REFERENCES ${DatabaseTableNames.receipts} (id) ON DELETE CASCADE
      )
    ''';

  @override
  ProductData fromMap(Map<String, dynamic> query) {
    return ProductData(
        id: query['id'],
        name: query[nameColumn] ?? '<invalid_name>',
        price: (query[priceColumn] ?? 0.0) as double ,
        receiptId: query[receiptIdColumn] ?? -1);
  }
}
