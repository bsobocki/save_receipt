import 'package:save_receipt/data/models/info.dart';
import 'package:save_receipt/data/models/product.dart';
import 'package:save_receipt/data/models/receipt.dart';
import 'package:save_receipt/data/models/shop.dart';

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
}
