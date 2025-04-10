import 'package:save_receipt/domain/entities/receipt_object.dart';
export 'package:save_receipt/domain/entities/receipt_object.dart';

class ReceiptModel {
  final String title;
  final String? imgPath;
  final List<ReceiptObjectModel> objects;
  final int? receiptId;

  const ReceiptModel({
    required this.title,
    this.receiptId,
    this.imgPath,
    required this.objects,
  });

  List<ReceiptObjectModel> getObjects(ReceiptObjectModelType type) {
    List<ReceiptObjectModel> objs = [];
    for (ReceiptObjectModel obj in objects) {
      if (obj.type == type) {
        objs.add(obj);
      }
    }
    return objs;
  }

  List<String> getValuesAsStr(ReceiptObjectModelType type) {
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

  List<ReceiptObjectModel> get infos => [
        ...getObjects(ReceiptObjectModelType.infoText),
        ...getObjects(ReceiptObjectModelType.infoDouble),
        ...getObjects(ReceiptObjectModelType.infoNumeric),
        ...getObjects(ReceiptObjectModelType.infoTime)
      ];
  List<ReceiptObjectModel> get time =>
      getObjects(ReceiptObjectModelType.infoTime);

  get prices => [
        ...getValuesAsStr(ReceiptObjectModelType.product),
        ...getValuesAsStr(ReceiptObjectModelType.infoDouble),
      ];
  get infoStr => getValuesAsStr(ReceiptObjectModelType.infoText);
  get timeStr => getValuesAsStr(ReceiptObjectModelType.infoTime);

  @override
  String toString() => 'img: $imgPath, [$objects]';
}
