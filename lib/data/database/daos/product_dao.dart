import 'package:save_receipt/data/database/daos/data_access_object.dart';
import 'package:save_receipt/data/models/product.dart';
import 'package:save_receipt/data/database/structure/names.dart';

class ProductDao extends Dao<ProductData> {
  @override
  Map<String, dynamic> toMap(ProductData object) {
    return {
      'id': object.id,
      'name': object.name,
      'price': object.price,
      'receipt_id': object.receiptId,
    };
  }

  @override
  String get createTableQuery => '''
      CREATE TABLE ${DatabaseTableNames.products}(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        receipt_id INTEGER,
        name TEXT,
        price REAL,
        FOREIGN KEY (receipt_id) REFERENCES receipts (id) ON DELETE CASCADE
      )
    ''';

  @override
  ProductData fromMap(Map<String, dynamic> query) {
    return ProductData(
        id: query['id'],
        name: query['name'] ?? '<invalid_name>',
        price: query['price'] ?? 0.0,
        receiptId: query['receipt_id'] ?? -1);
  }
}
