import 'dart:async';

import 'package:path/path.dart';
import 'package:save_receipt/data/database/daos/info_dao.dart';
import 'package:save_receipt/data/database/daos/product_dao.dart';
import 'package:save_receipt/data/database/daos/receipt_dao.dart';
import 'package:save_receipt/data/database/daos/shop_dao.dart';
import 'package:save_receipt/data/models/info.dart';
import 'package:save_receipt/data/models/product.dart';
import 'package:save_receipt/data/models/receipt.dart';
import 'package:save_receipt/data/models/shop.dart';
import 'package:save_receipt/domain/repositories/repository.dart';
import 'package:save_receipt/data/database/structure/names.dart';
import 'package:sqflite/sqflite.dart';

typedef QueryResult = Map<String, dynamic>;

class ReceiptDatabaseRepository implements IReceiptRepository {
  static final _instance = ReceiptDatabaseRepository._createInstance();
  static ReceiptDatabaseRepository get = _instance;
  bool isInitialized = false;

  late Database _db;

  final ReceiptDao _receiptDao = ReceiptDao();
  final ProductDao _productDao = ProductDao();
  final InfoDao _infoDao = InfoDao();
  final ShopDao _shopDao = ShopDao();

  ReceiptDatabaseRepository._createInstance();

  Future<Database> get database async {
    if (!isInitialized) await _init();
    return _db;
  }

  Future _init() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'receipt_database.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(_receiptDao.createTableQuery);
      },
    );
    isInitialized = true;
  }

  Future<int> insertObject(QueryResult data, String tableName) async {
    final Database db = await database;
    return await db.insert(
      tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateObject(QueryResult data, String tableName) async {
    final Database db = await database;
    return await db.update(
      tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteObject(int id, String tableName) async {
    final Database db = await database;
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<QueryResult>> getReceiptObjects(
      int receiptId, String tableName) async {
    final Database db = await database;
    return db.query(tableName, where: 'receipt_id = ?', whereArgs: [receiptId]);
  }

  @override
  Future<int> insertReceipt(ReceiptData data) async =>
      insertObject(_receiptDao.toMap(data), DatabaseTableNames.receipts);

  @override
  Future<int> insertProduct(ProductData data) async =>
      insertObject(_productDao.toMap(data), DatabaseTableNames.products);

  @override
  Future<int> insertInfo(InfoData data) async =>
      insertObject(_infoDao.toMap(data), DatabaseTableNames.info);

  @override
  Future<int> insertShop(ShopData data) async =>
      insertObject(_shopDao.toMap(data), DatabaseTableNames.shops);

  @override
  Future<int> updateReceipt(ReceiptData data) async =>
      updateObject(_receiptDao.toMap(data), DatabaseTableNames.receipts);

  @override
  Future<int> updateProduct(ProductData data) async =>
      updateObject(_productDao.toMap(data), DatabaseTableNames.products);

  @override
  Future<int> updateInfo(InfoData data) async =>
      updateObject(_infoDao.toMap(data), DatabaseTableNames.info);

  @override
  Future<int> updateShop(ShopData data) async =>
      updateObject(_shopDao.toMap(data), DatabaseTableNames.shops);

  @override
  Future<int> deleteReceipt(int id) async =>
      deleteObject(id, DatabaseTableNames.receipts);

  @override
  Future<int> deleteProduct(int id) async =>
      deleteObject(id, DatabaseTableNames.products);

  @override
  Future<int> deleteInfo(int id) async =>
      deleteObject(id, DatabaseTableNames.info);

  @override
  Future<int> deleteShop(int id) async =>
      deleteObject(id, DatabaseTableNames.shops);

  @override
  Future<List<InfoData>> getAllInfoFromReceipt(int receiptId) async {
    return _infoDao
        .fromList(await getReceiptObjects(receiptId, DatabaseTableNames.info));
  }

  @override
  Future<List<ProductData>> getAllProductFromReceipt(int receiptId) async {
    return _productDao.fromList(
        await getReceiptObjects(receiptId, DatabaseTableNames.products));
  }

  @override
  Future<List<ReceiptData>> getAllReceipts() async {
    final Database db = await database;
    return _receiptDao.fromList(await db.query(DatabaseTableNames.receipts));
  }

  @override
  Future<ReceiptData?> getReceipt(int id) async {
    final Database db = await database;
    List<ReceiptData> results = _receiptDao.fromList(await db
        .query(DatabaseTableNames.receipts, where: 'id = ?', whereArgs: [id], limit: 1));
    return results.isEmpty ? null : results.first;
  }

  Future close() async => _db.close();
}
