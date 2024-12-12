import 'package:save_receipt/domain/entities/receipt_object.dart';
export 'package:save_receipt/domain/entities/receipt_object.dart';

class ReceiptModel {
  final String? imgPath;
  final List<ReceiptObjectModel> objects;
  final int? receiptId;

  const ReceiptModel({this.receiptId, this.imgPath, required this.objects});

  List<ReceiptObjectModel> getObjects(ReceiptObjectModelType type) {
    List<ReceiptObjectModel> objs = [];
    for (ReceiptObjectModel obj in objects) {
      if (obj.type == type) {
        objs.add(obj);
      }
    }
    return objs;
  }

  getValuesAsStr(ReceiptObjectModelType type) {
    List<String> objs = [];
    for (ReceiptObjectModel obj in objects) {
      if (obj.type == type && obj.value != null) {
        objs.add(obj.value!);
      }
    }
    return objs;
  }

  List<ReceiptObjectModel> get products =>
      getObjects(ReceiptObjectModelType.product);

  List<ReceiptObjectModel> get info => getObjects(ReceiptObjectModelType.info);

  get prices => products.map((e) => e.value!).toList();
  get dates => getObjects(ReceiptObjectModelType.date);
  get infoStr => getValuesAsStr(ReceiptObjectModelType.info);
  get datesStr => getValuesAsStr(ReceiptObjectModelType.date);

  @override
  String toString() => 'img: $imgPath, [$objects]';
}

