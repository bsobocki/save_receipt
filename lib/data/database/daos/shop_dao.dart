import 'package:save_receipt/data/database/daos/data_access_object.dart';
import 'package:save_receipt/data/models/shop.dart';
import 'package:save_receipt/data/database/structure/names.dart';

class ShopDao extends Dao<ShopData> {
  @override
  Map<String, dynamic> toMap(ShopData object) {
    return {
      'id': object.id,
      'name': object.name,
    };
  }

  @override
  String get createTableQuery => '''
      CREATE TABLE ${DatabaseTableNames.info}(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
      )
    ''';

  @override
  ShopData fromMap(Map<String, dynamic> query) {
    return ShopData(
      id: query['id'],
      name: query['name'] ?? '<invalid_name>',
    );
  }
}
