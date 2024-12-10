import 'package:save_receipt/domain/entities/all_values.dart';
import 'package:save_receipt/domain/entities/receipt_object.dart';
import 'package:save_receipt/domain/entities/receipt.dart';
import 'package:save_receipt/data/values.dart';

class ReceiptModelController {
  String? _receiptImagePath;
  late AllReceiptValuesController _allValues;
  List<ReceiptObjectModel> _receiptObjects = [];

  ReceiptModelController(final ReceiptModel receipt) {
    _receiptImagePath = receipt.imgPath;
    _receiptObjects = [];
    _allValues = AllReceiptValuesController.fromReceipt(receipt);
    _receiptObjects = receipt.objects;
  }

  void changeItemToValue(int index) {
    if (indexExists(index)) {
      _allValues.insertValue(_receiptObjects[index].text);
      _receiptObjects.removeAt(index);
    }
  }

  void changeValueToItem(int index) {
    if (indexExists(index) && dataFieldHasValue(index)) {
      _allValues.removeValue(_receiptObjects[index].value!);
      _receiptObjects.add(
        ReceiptObjectModel(
          type: ReceiptObjectModelType.object,
          text: _receiptObjects[index].value!,
          value: null,
        ),
      );
      _receiptObjects[index].value = null;
    }
  }

  void toggleEditModeOfDataField(int index) {
    if (indexExists(index)) {
      _receiptObjects[index].isEditing = !_receiptObjects[index].isEditing;
    }
  }

  ReceiptObjectModel? dataFieldAt(int index) {
    if (indexExists(index)) {
      return _receiptObjects[index];
    }
    return null;
  }

  void removeDataField(int index) {
    if (indexExists(index)) {
      _receiptObjects.removeAt(index);
    }
  }

  AllValuesModel get allValuesModel => _allValues.model;
  String? get imgPath => _receiptImagePath;
  List<ReceiptObjectModel> get dataFields => _receiptObjects;

  bool indexExists(int index) => index >= 0 && index < _receiptObjects.length;
  bool dataFieldHasValue(int index) => _receiptObjects[index].value != null;
  bool get imgPathExists => imgPath != null;
}
