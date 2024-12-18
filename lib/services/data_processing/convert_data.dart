import 'package:save_receipt/domain/entities/receipt_object.dart';
import 'package:save_receipt/domain/entities/receipt.dart';

ReceiptModel convertToReceipt(List<ReceiptObjectModel> data) {
  List<ReceiptObjectModel> objects = [];
  return ReceiptModel(objects: objects);
}
