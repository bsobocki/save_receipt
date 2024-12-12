import 'package:save_receipt/data/models/document.dart';
import 'package:save_receipt/data/models/entities/info.dart';
import 'package:save_receipt/data/models/entities/product.dart';
import 'package:save_receipt/data/models/entities/receipt.dart';
import 'package:save_receipt/data/models/entities/shop.dart';

abstract class IReceiptRepository {
  Future<int> insertReceipt(ReceiptData data);
  Future<int> insertProduct(ProductData data);
  Future<int> insertInfo(InfoData data);
  Future<int> insertShop(ShopData data);

  Future<int> updateReceipt(ReceiptData data);
  Future<int> updateProduct(ProductData data);
  Future<int> updateInfo(InfoData data);
  Future<int> updateShop(ShopData data);

  Future<int> deleteReceipt(int id);
  Future<int> deleteProduct(int id);
  Future<int> deleteInfo(int id);
  Future<int> deleteShop(int id);

  Future<ReceiptData?> getReceipt(final int id);
  Future<List<ReceiptData>> getAllReceipts();
  Future<List<ProductData>> getAllProductFromReceipt(final int receiptId);
  Future<List<InfoData>> getAllInfoFromReceipt(final int receiptId);
  Future<ReceiptDocumentData?> getDocumentDataForReceipt(int receiptId);
  Future<List<ReceiptDocumentData>> getAllDocumentDatas();
}
