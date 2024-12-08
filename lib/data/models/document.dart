import 'package:save_receipt/data/models/info.dart';
import 'package:save_receipt/data/models/product.dart';
import 'package:save_receipt/data/models/receipt.dart';
import 'package:save_receipt/data/models/shop.dart';

class ReceiptDocumentData {
  final ReceiptData receipt;
  final List<ProductData> products;
  final List<InfoData> infos;
  final ShopData? shop;

  const ReceiptDocumentData({
    required this.receipt,
    required this.products,
    required this.infos,
    this.shop,
  });
}
