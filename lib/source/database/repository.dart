import 'package:save_receipt/source/database/models/info.dart';
import 'package:save_receipt/source/database/models/product.dart';
import 'package:save_receipt/source/database/models/receipt.dart';
import 'package:save_receipt/source/database/models/shop.dart';

abstract class IReceiptRepository {
  Future<int> insertReceipt(ReceiptData data);
  Future<int> insertProduct(ProductData data);
  Future<int> insertInfo(InfoData data);
  Future<int> insertShop(ShopData data);

  Future<int> deleteReceipt(int id);
  Future<int> deleteProduct(int id);
  Future<int> deleteInfo(int id);
  Future<int> deleteShop(int id);

  Future<ReceiptData?> getReceipt(final int id);
  Future<List<ReceiptData>> getAllReceipts();
  Future<List<ProductData>> getAllProductFromReceipt(final int receiptId);
  Future<List<InfoData>> getAllInfoFromReceipt(final int receiptId);
}
