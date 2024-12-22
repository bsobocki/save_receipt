import 'package:save_receipt/data/converters/data_converter.dart';
import 'package:save_receipt/data/models/document.dart';
import 'package:save_receipt/data/models/entities/info.dart';
import 'package:save_receipt/data/models/entities/product.dart';
import 'package:save_receipt/data/models/entities/receipt.dart';
import 'package:save_receipt/data/repositories/database_repository.dart';
import 'package:save_receipt/domain/entities/all_values.dart';
import 'package:save_receipt/domain/entities/receipt.dart';
import 'package:save_receipt/data/values.dart';

class ReceiptModelController {
  String? _receiptImagePath;
  late AllReceiptValuesController _allValues;
  List<ReceiptObjectModel> _receiptObjects = [];
  List<int> _deletedProductsIds = [];
  List<int> _deletedInfosIds = [];
  int? receiptId;

  Future<int> saveReceipt(ReceiptModel model) async {
    int receiptId = -1;
    var dbRepo = ReceiptDatabaseRepository.get;
    ReceiptDocumentData data;

    if (model.receiptId != null) {
      data = ReceiptDataConverter.toDocumentDataForExistingReceipt(model);
      receiptId = await dbRepo.updateReceipt(data.receipt);
    } else {
      ReceiptData receiptData = ReceiptDataConverter.toReceiptData(model);
      receiptId = await dbRepo.insertReceipt(receiptData);
      data = ReceiptDataConverter.toDocumentData(model, receiptId);
    }

    // because of conflictAlgorithm: ConflictAlgorithm.replace
    // inserting of existing object will work similar to update
    for (ProductData prod in data.products) {
      await dbRepo.insertProduct(prod);
    }
    for (InfoData info in data.infos) {
      await dbRepo.insertInfo(info);
    }
    if (data.shop != null) {
      await dbRepo.insertShop(data.shop!);
    }

    for (int id in _deletedProductsIds) {
      await dbRepo.deleteProduct(id);
    }
    for (int id in _deletedInfosIds) {
      await dbRepo.deleteInfo(id);
    }

    return receiptId;
  }

  Future<void> deleteReceipt(int receiptId) async {
    await ReceiptDatabaseRepository.get.deleteReceipt(receiptId);
  }

  ReceiptModelController(final ReceiptModel receipt) {
    _receiptImagePath = receipt.imgPath;
    _receiptObjects = [];
    _allValues = AllReceiptValuesController.fromReceipt(receipt);
    _receiptObjects = receipt.objects;
    receiptId = receipt.receiptId;
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
      int? id = _receiptObjects[index].dataId;
      if (id != null) {
        ReceiptObjectModelType type = _receiptObjects[index].type;
        if (type == ReceiptObjectModelType.product) {
          _deletedProductsIds.add(id);
        } else if (type == ReceiptObjectModelType.infoText) {
          _deletedInfosIds.add(id);
        }
      }
      _receiptObjects.removeAt(index);
    }
  }

  AllValuesModel get allValuesModel => _allValues.model;
  String? get imgPath => _receiptImagePath;
  List<ReceiptObjectModel> get objects => _receiptObjects;
  ReceiptModel get model => ReceiptModel(
      receiptId: receiptId, objects: objects, imgPath: _receiptImagePath);

  bool indexExists(int index) => index >= 0 && index < _receiptObjects.length;
  bool dataFieldHasValue(int index) => _receiptObjects[index].value != null;
  bool get imgPathExists => imgPath != null;
}
