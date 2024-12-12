import 'package:save_receipt/data/models/database_entities.dart';

class ReceiptDocumentData {
  final ReceiptData receipt;
  final List<ProductData> products;
  final List<InfoData> infos;
  final ShopData? shop;

  ReceiptDocumentData({
    required this.receipt,
    required this.products,
    required this.infos,
    this.shop,
  });

  @override
  String toString() {
    String str = '$receipt\n';
    str += 'products:\n';
    for (var prod in products) {
      str += '$prod\n';
    }
    str += 'infos:\n';
    for (var info in infos) {
      str += '$info\n';
    }
    str += 'shop: $shop';
    return str;
  }
}
