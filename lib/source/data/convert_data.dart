import 'package:save_receipt/source/data/structures/data_field.dart';
import 'package:save_receipt/source/data/structures/receipt.dart';

Receipt convertToReceipt(List<DataFieldModel> data) {
  List<ReceiptObject> objects = [];
  return Receipt(objects: objects);
}
