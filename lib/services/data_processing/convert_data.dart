import 'package:save_receipt/domain/entities/receipt.dart';

ReceiptModel convertToReceiptModel(List<ReceiptObjectModel> data) {
  List<ReceiptObjectModel> objects = [];
  return ReceiptModel(title: '', objects: objects);
}
