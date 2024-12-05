import 'package:save_receipt/source/data/structures/data_field.dart';
import 'package:save_receipt/source/data/structures/receipt.dart';

ReceiptModel convertToReceipt(List<DataFieldModel> data) {
  List<ReceiptModelObject> objects = [];
  return ReceiptModel(objects: objects);
}
