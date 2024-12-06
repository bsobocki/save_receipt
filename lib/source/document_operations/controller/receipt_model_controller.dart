import 'package:save_receipt/source/data/structures/data_field.dart';
import 'package:save_receipt/source/data/structures/receipt.dart';
import 'package:save_receipt/source/data/values.dart';

class ReceiptModelController {
  String? _receiptImagePath;
  late AllReceiptValuesController _allValues;
  List<DataFieldModel> _dataFields = [];

  ReceiptModelController(final ReceiptModel receipt) {
    _receiptImagePath = receipt.imgPath;
    _dataFields = [];
    _allValues = AllReceiptValuesController.fromReceipt(receipt);

    for (ReceiptModelObject obj in receipt.objects) {
      String text = obj.text;
      String? value;

      switch (obj.type) {
        case ReceiptModelObjectType.product:
          value = (obj as ReceiptModelProduct).price.toString();
          break;

        case ReceiptModelObjectType.date:
          value = (obj as ReceiptModelDate).date;
          break;

        case ReceiptModelObjectType.info:
          value = (obj as ReceiptModelInfo).info;
          break;
      }

      _dataFields.add(
        DataFieldModel(
          type: obj.type,
          text: text,
          value: value,
        ),
      );
    }
  }

  void changeItemToValue(int index) {
    if (indexExists(index)) {
      _allValues.insertValue(_dataFields[index].text);
      _dataFields.removeAt(index);
    }
  }

  void changeValueToItem(int index) {
    if (indexExists(index) && dataFieldHasValue(index)) {
      _allValues.removeValue(_dataFields[index].value!);
      _dataFields.add(
        DataFieldModel(
          type: ReceiptModelObjectType.object,
          text: _dataFields[index].value!,
          value: null,
        ),
      );
      _dataFields[index].value = null;
    }
  }

  void toggleEditModeOfDataField(int index) {
    if (indexExists(index)) {
      _dataFields[index].isEditing = !_dataFields[index].isEditing;
    }
  }

  DataFieldModel? dataFieldAt(int index) {
    if (indexExists(index)) {
      return _dataFields[index];
    }
    return null;
  }

  void removeDataField(int index) {
    if (indexExists(index)) {
      _dataFields.removeAt(index);
    }
  }

  AllValuesModel get allValuesModel => _allValues.model;
  String? get imgPath => _receiptImagePath;
  List<DataFieldModel> get dataFields => _dataFields;

  bool indexExists(int index) => index >= 0 && index < _dataFields.length;
  bool dataFieldHasValue(int index) => _dataFields[index].value != null;
  bool get imgPathExists => imgPath != null;
}
