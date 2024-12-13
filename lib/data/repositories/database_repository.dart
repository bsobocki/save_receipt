import 'dart:async';
import 'package:collection/collection.dart';

import 'package:path/path.dart';
import 'package:save_receipt/data/database/daos/info_dao.dart';
import 'package:save_receipt/data/database/daos/product_dao.dart';
import 'package:save_receipt/data/database/daos/receipt_dao.dart';
import 'package:save_receipt/data/database/daos/shop_dao.dart';
import 'package:save_receipt/data/models/document.dart';
import 'package:save_receipt/data/models/entities/info.dart';
import 'package:save_receipt/data/models/entities/product.dart';
import 'package:save_receipt/data/models/entities/receipt.dart';
import 'package:save_receipt/data/models/entities/shop.dart';
import 'package:save_receipt/domain/repositories/repository.dart';
import 'package:save_receipt/data/database/structure/names.dart';
import 'package:sqflite/sqflite.dart';

typedef QueryResult = Map<String, dynamic>;

const String databaseName = 'receipt_database.db';

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
    print("i'm in get database XD");
    if (!isInitialized) await _init();
    return _db;
  }

  Future _init() async {
    try {
      print(
          "----=-=-=-=-=-=- INIT DATABASEEEEE!!!! _-----------------=-=-=-=-=-=");
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, databaseName);
      _db = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          try {
            await db.execute(_shopDao.createTableQuery);
            await db.execute(_receiptDao.createTableQuery);
            await db.execute(_productDao.createTableQuery);
            await db.execute(_infoDao.createTableQuery);
            print(
                "----=-=-=-=-=-=- ALLL TABLES HAS BEEN CREATED!!!! _-----------------=-=-=-=-=-=");
          } catch (e) {
            print("Error creating tables: $e");
            rethrow;
          }
        },
        onOpen: (db) {
          print("--------- Database opened successfully");
        },
      );
      isInitialized = true;
      print("================ Database initialization completed");
    } catch (e) {
      print("+++++++++++++++++++ Error initializing database: $e");
      isInitialized = false;
      rethrow;
    }
  }

  Future<void> deleteDb() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, databaseName);
    await deleteDatabase(path);
    isInitialized = false;
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
    print("updating: $data");
    return await db.update(
      tableName,
      data,
      where: 'id = ?',
      whereArgs: [data['id']],
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
    return db.query(
      tableName,
      where: 'receipt_id = ?',
      whereArgs: [receiptId],
    );
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
    print("i'm in getAllReceipts !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    final Database db = await database;
    try {
      final receiptsList = await db.query(DatabaseTableNames.receipts);
      print("receiptsList: $receiptsList");
      return _receiptDao.fromList(receiptsList);
    } catch (e) {
      print("Error loading ALL RECEIPTS: $e");
    }
    return [];
  }

  @override
  Future<ReceiptData?> getReceipt(int id) async {
    final Database db = await database;
    List<ReceiptData> results = _receiptDao.fromList(await db.query(
        DatabaseTableNames.receipts,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1));
    return results.isEmpty ? null : results.first;
  }

  Future close() async => _db.close();

  @override
  Future<ReceiptDocumentData?> getDocumentDataForReceipt(int receiptId) async {
    ReceiptData? receipt = await getReceipt(receiptId);
    if (receipt != null) {
      List<ProductData> products = await getAllProductFromReceipt(receiptId);
      List<InfoData> infos = await getAllInfoFromReceipt(receiptId);
      return ReceiptDocumentData(
          receipt: receipt, products: products, infos: infos);
    }
    return null;
  }

  @override
  Future<List<ReceiptDocumentData>> getAllDocumentDatas() async {
    print(
        "########################## i'm in getAllDocumentDatas ##########################");
    final Database db = await database;

    if (!db.isOpen) {
      print("ERROR: Database is not open!");
      return [];
    }

    print("Database is open! ");
    List<ReceiptData> receipts = await getAllReceipts();
    print("receipts: $receipts");
    final List<ProductData> allProducts =
        _productDao.fromList(await db.query(DatabaseTableNames.products));
    print("allProducts: $allProducts");
    final List<InfoData> allInfos =
        _infoDao.fromList(await db.query(DatabaseTableNames.info));
    print("allInfos: $allInfos");
    final productsMap = groupBy(allProducts, (ProductData p) => p.receiptId);
    final infosMap = groupBy(allInfos, (InfoData i) => i.receiptId);

    print("productsMap: $productsMap");
    print("infosMap: $infosMap");

    return receipts
        .map((receipt) => ReceiptDocumentData(
            receipt: receipt,
            products: productsMap[receipt.id] ?? [],
            infos: infosMap[receipt.id] ?? []))
        .toList();
  }

  Future<void> printDatabase() async {
    final Database db = await database;

    print('\n=== RECEIPTS ===');
    List<Map<String, dynamic>> receipts =
        await db.query(DatabaseTableNames.receipts);
    for (var receipt in receipts) {
      print(receipt);
    }

    print('\n=== PRODUCTS ===');
    List<Map<String, dynamic>> products =
        await db.query(DatabaseTableNames.products);
    for (var product in products) {
      print(product);
    }

    print('\n=== INFO ===');
    List<Map<String, dynamic>> infos = await db.query(DatabaseTableNames.info);
    for (var info in infos) {
      print(info);
    }

    print('\n=== SHOPS ===');
    List<Map<String, dynamic>> shops = await db.query(DatabaseTableNames.shops);
    for (var shop in shops) {
      print(shop);
    }

    print('\n=== END OF DATABASE ===\n');
  }
}
