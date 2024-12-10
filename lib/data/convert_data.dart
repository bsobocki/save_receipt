import 'package:save_receipt/domain/entities/data_field.dart';
import 'package:save_receipt/domain/entities/receipt.dart';

ReceiptModel convertToReceipt(List<ReceiptObjectModel> data) {
  List<ReceiptObjectModel> objects = [];
  return ReceiptModel(objects: objects);
}
