import 'package:save_receipt/domain/entities/data_field.dart';
import 'package:save_receipt/domain/entities/receipt.dart';

ReceiptModel convertToReceipt(List<DataFieldModel> data) {
  List<ReceiptModelObject> objects = [];
  return ReceiptModel(objects: objects);
}
