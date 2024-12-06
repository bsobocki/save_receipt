import 'dart:async';

import 'package:path/path.dart';
import 'package:save_receipt/source/database/data_access/info_dao.dart';
import 'package:save_receipt/source/database/data_access/product_dao.dart';
import 'package:save_receipt/source/database/data_access/receipt_dao.dart';
import 'package:save_receipt/source/database/data_access/shop_dao.dart';
import 'package:save_receipt/source/database/models/info.dart';
import 'package:save_receipt/source/database/models/product.dart';
import 'package:save_receipt/source/database/models/receipt.dart';
import 'package:save_receipt/source/database/models/shop.dart';
import 'package:save_receipt/source/database/structure/names.dart';
import 'package:sqflite/sqflite.dart';

class ReceiptDatabaseProvider {
  static final _instance = ReceiptDatabaseProvider._createInstance();
  static ReceiptDatabaseProvider get = _instance;
  bool isInitialized = false;

  late Database _db;

  final ReceiptDao _receiptDao = ReceiptDao();
  final ProductDao _productDao = ProductDao();
  final InfoDao _infoDao = InfoDao();
  final ShopDao _shopDao = ShopDao();

  ReceiptDatabaseProvider._createInstance();

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
  }

  Future<int> insertObject(Map<String, dynamic> data, String tableName) async {
    final Database db = await database;
    return await db.insert(
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

  Future<int> insertReceipt(ReceiptData data) async =>
      insertObject(_receiptDao.toMap(data), DatabaseTableNames.receipts);

  Future<int> insertProduct(ProductData data) async =>
      insertObject(_productDao.toMap(data), DatabaseTableNames.products);

  Future<int> insertInfo(InfoData data) async =>
      insertObject(_infoDao.toMap(data), DatabaseTableNames.info);

  Future<int> insertShop(ShopData data) async =>
      insertObject(_shopDao.toMap(data), DatabaseTableNames.shops);

  Future<int> deleteReceipt(int id) async =>
      deleteObject(id, DatabaseTableNames.receipts);

  Future<int> deleteProduct(int id) async =>
      deleteObject(id, DatabaseTableNames.products);

  Future<int> deleteInfo(int id) async =>
      deleteObject(id, DatabaseTableNames.info);

  Future<int> deleteShop(int id) async =>
      deleteObject(id, DatabaseTableNames.shops);

  Future close() async => _db.close();
}
