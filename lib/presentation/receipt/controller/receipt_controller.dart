import 'package:flutter/material.dart';
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
  List<int> _selectedObjects = [];
  List<ReceiptObjectModel> _infos = [];
  List<ReceiptObjectModel> _products = [];
  List<ReceiptObjectModel> _dates = [];
  final List<int> _deletedProductsIds = [];
  final List<int> _deletedInfoTextIds = [];
  final List<int> _deletedInfoDateIds = [];
  final List<int> _deletedInfoDoubleIds = [];
  final List<int> _deletedInfoNumericIds = [];
  final ValueNotifier<bool> _dataChangedNotifier = ValueNotifier<bool>(false);
  bool _areProductsEdited = true;
  bool _isSelectModeEnabled = false;
  int _editingObjectFieldIndex = -1;
  int? _receiptId;

  ReceiptModelController(
      final ReceiptModel receipt, AllValuesModel? allValuesModel) {
    _receiptImagePath = receipt.imgPath;
    _allValues = allValuesModel != null
        ? AllReceiptValuesController(model: allValuesModel)
        : AllReceiptValuesController.fromReceipt(receipt);
    _products = receipt.products;
    _infos = receipt.infos;
    _dates = receipt.dates;
    _receiptId = receipt.receiptId;
  }

  void trackChange() {
    _dataChangedNotifier.value = true;
  }

  void resetChangesTracking() {
    _dataChangedNotifier.value = false;
  }

  Future<void> saveReceipt() async {
    var dbRepo = ReceiptDatabaseRepository.get;
    ReceiptDocumentData data;
    ReceiptModel receiptModel = model;

    if (_receiptId != null) {
      data =
          ReceiptDataConverter.toDocumentDataForExistingReceipt(receiptModel);
      _receiptId = await dbRepo.updateReceipt(data.receipt);
    } else {
      ReceiptData receiptData =
          ReceiptDataConverter.toReceiptData(receiptModel);
      _receiptId = await dbRepo.insertReceipt(receiptData);
      data = ReceiptDataConverter.toDocumentData(model, _receiptId!);
    }

    // because of conflictAlgorithm: ConflictAlgorithm.replace
    // existing object insertion will work similar to update
    for (ProductData product in data.products) {
      await dbRepo.insertProduct(product);
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
    for (int id in _deletedInfoTextIds) {
      await dbRepo.deleteInfo(id);
    }
    for (int id in _deletedInfoDateIds) {
      await dbRepo.deleteInfo(id);
    }
    for (int id in _deletedInfoDoubleIds) {
      await dbRepo.deleteInfo(id);
    }
    for (int id in _deletedInfoNumericIds) {
      await dbRepo.deleteInfo(id);
    }

    resetChangesTracking();
  }

  Future<void> deleteReceipt() async {
    if (_receiptId != null) {
      await ReceiptDatabaseRepository.get.deleteReceipt(_receiptId!);
    }
  }

  void changeInfoToValue(int index) {
    if (infoIndexExists(index)) {
      _allValues.insertValue(_infos[index].text);
      removeInfo(index);
    }
  }

  void changeProductToValue(int index) {
    if (productIndexExists(index)) {
      _allValues.insertValue(_products[index].text);
      removeProduct(index);
    }
  }

  void changeValueToInfo(int index) {
    if (infoIndexExists(index) && infoHasValue(index)) {
      _allValues.removeValue(_infos[index].value!);
      _infos.add(
        ReceiptObjectModel(
          type: ReceiptObjectModelType.object,
          text: _infos[index].value!,
          value: null,
        ),
      );
      trackChange();
      _infos[index].value = null;
    }
  }

  void changeInfoValueType(ReceiptObjectModelType newType, int index) {
    if (infoIndexExists(index)) {
      ReceiptObjectModelType oldType = _infos[index].type;
      _infos[index].type = newType;
      int? id = _infos[index].dataId;

      if (id != null) {
        switch (oldType) {
          case ReceiptObjectModelType.infoText:
            _deletedInfoTextIds.add(id);
            break;
          case ReceiptObjectModelType.infoDouble:
            _deletedInfoDoubleIds.add(id);
            break;
          case ReceiptObjectModelType.infoNumeric:
            _deletedInfoNumericIds.add(id);
            break;
          case ReceiptObjectModelType.infoDate:
            _deletedInfoDateIds.add(id);
            break;
          default:
            break;
        }
      }
      trackChange();
    }
  }

  void changeProductToInfoDouble(int index) {
    if (productIndexExists(index)) {
      _products[index].type = ReceiptObjectModelType.infoDouble;
      _infos.add(_products[index]);
      removeProduct(index);
    }
  }

  void addEmptyProduct() {
    _products.add(
      ReceiptObjectModel(
        type: ReceiptObjectModelType.product,
        text: "<new-product>",
        value: "0.0",
      ),
    );
    trackChange();
  }

  void addEmptyInfo() {
    _infos.add(
      ReceiptObjectModel(
        type: ReceiptObjectModelType.infoText,
        text: "<new-info-text>",
      ),
    );
    trackChange();
  }

  bool changeInfoDoubleToProduct(int index) {
    if (infoIndexExists(index)) {
      if (_infos[index].value != null) {
        _infos[index].type = ReceiptObjectModelType.product;
        _products.add(_infos[index]);
        removeInfo(index);
      } else {
        return false;
      }
    }
    return true;
  }

  void removeInfo(int index) {
    if (infoIndexExists(index)) {
      if (_editingObjectFieldIndex == index) {
        resetEditModeIndex();
      }
      removeInfoObject(_infos[index]);
    }
  }

  void removeInfoObject(ReceiptObjectModel info) {
    int? id = info.dataId;
    if (id != null) {
      switch (info.type) {
        case ReceiptObjectModelType.infoText:
          _deletedInfoTextIds.add(id);
          break;
        case ReceiptObjectModelType.infoDouble:
          _deletedInfoDoubleIds.add(id);
          break;
        case ReceiptObjectModelType.infoNumeric:
          _deletedInfoNumericIds.add(id);
          break;
        case ReceiptObjectModelType.infoDate:
          _deletedInfoDateIds.add(id);
          break;
        default:
          break;
      }
    }
    _infos.remove(info);
    trackChange();
  }

  void removeProduct(int index) {
    if (productIndexExists(index)) {
      if (_editingObjectFieldIndex == index) {
        resetEditModeIndex();
      }
      removeProductObject(_products[index]);
    }
  }

  void removeProductObject(ReceiptObjectModel product) {
    int? id = product.dataId;
    if (id != null) {
      _deletedProductsIds.add(id);
    }
    _products.remove(product);
    trackChange();
  }

  void setProductsEditing() {
    _areProductsEdited = true;
    resetEditModeIndex();
    _selectedObjects = [];
  }

  void setInfoEditing() {
    _areProductsEdited = false;
    resetEditModeIndex();
    _selectedObjects = [];
  }

  void resetEditModeIndex() => _editingObjectFieldIndex = -1;

  void setEditModeForInfo(int index) {
    if (!_areProductsEdited && infoIndexExists(index)) {
      if (_editingObjectFieldIndex != index) {
        _editingObjectFieldIndex = index;
      } else {
        resetEditModeIndex();
      }
    }
  }

  void setEditModeForProduct(int index) {
    if (_areProductsEdited && productIndexExists(index)) {
      if (_editingObjectFieldIndex != index) {
        _editingObjectFieldIndex = index;
      } else {
        resetEditModeIndex();
      }
    }
  }

  void setSelectionMode() {
    _isSelectModeEnabled = true;
  }

  void toggleSelectMode() {
    _isSelectModeEnabled = !_isSelectModeEnabled;
    _selectedObjects = [];
  }

  void toggleProductSelection(int index) {
    if (isProductSelected(index)) {
      unselectProduct(index);
    } else {
      selectProduct(index);
    }
  }

  void toggleInfoSelection(int index) {
    if (isInfoSelected(index)) {
      unselectInfo(index);
    } else {
      selectInfo(index);
    }
  }

  void selectProduct(int index) {
    if (_areProductsEdited && productIndexExists(index)) {
      _selectedObjects.add(index);
    }
  }

  void selectInfo(int index) {
    if (!_areProductsEdited && infoIndexExists(index)) {
      _selectedObjects.add(index);
    }
  }

  void unselectProduct(int index) {
    if (_areProductsEdited && productIndexExists(index)) {
      _selectedObjects.remove(index);
    }
  }

  void unselectInfo(int index) {
    if (!_areProductsEdited && infoIndexExists(index)) {
      _selectedObjects.remove(index);
    }
  }

  AllValuesModel get allValuesModel => _allValues.model;

  String? get imgPath => _receiptImagePath;

  List<ReceiptObjectModel> get objects => [
        ..._products,
        ..._infos,
      ];

  ReceiptModel get model => ReceiptModel(
      receiptId: _receiptId, objects: objects, imgPath: _receiptImagePath);

  List<ReceiptObjectModel> get products => _products;

  List<ReceiptObjectModel> get infos => _infos;

  List<ReceiptObjectModel> get dates => _dates;

  bool productIndexExists(int index) => index >= 0 && index < _products.length;

  bool infoIndexExists(int index) => index >= 0 && index < _infos.length;

  bool infoHasValue(int index) => _infos[index].value != null;

  ReceiptObjectModel? infoAt(int index) =>
      infoIndexExists(index) ? _infos[index] : null;

  ReceiptObjectModel? productAt(int index) =>
      productIndexExists(index) ? _products[index] : null;

  bool get imgPathExists => imgPath != null;

  bool get areProductsEdited => _areProductsEdited;

  bool get dataChanged => _dataChangedNotifier.value;

  ValueNotifier<bool> get dataChangedNotifier => _dataChangedNotifier;

  bool get isSelectModeEnabled => _isSelectModeEnabled;

  bool isProductInEditMode(int index) =>
      _areProductsEdited &&
      productIndexExists(index) &&
      index == _editingObjectFieldIndex;

  bool isInfoInEditMode(int index) =>
      !_areProductsEdited &&
      infoIndexExists(index) &&
      index == _editingObjectFieldIndex;

  bool isProductSelected(int index) =>
      _areProductsEdited &&
      productIndexExists(index) &&
      _selectedObjects.contains(index);

  bool isInfoSelected(int index) =>
      !_areProductsEdited &&
      infoIndexExists(index) &&
      _selectedObjects.contains(index);

  void changeSelectedInfoValueType(ReceiptObjectModelType type) {
    for (int index in _selectedObjects) {
      changeInfoValueType(type, index);
    }
    toggleSelectMode();
  }

  void changeSelectedInfoToValue() {
    List<ReceiptObjectModel> selectedInfos = _selectedObjects
        .where((index) => infoIndexExists(index))
        .map((index) => _infos[index])
        .toList();

    for (ReceiptObjectModel info in selectedInfos) {
      _allValues.insertValue(info.text);
      removeInfoObject(info);
    }
    toggleSelectMode();
  }

  bool changeSelectedInfoToProducts() {
    List<ReceiptObjectModel> selectedInfos = _selectedObjects
        .where((index) => infoIndexExists(index))
        .map((index) => _infos[index])
        .toList();
    bool status = true;

    for (ReceiptObjectModel info in selectedInfos) {
      if (info.value != null &&
          info.type == ReceiptObjectModelType.infoDouble) {
        info.type = ReceiptObjectModelType.product;
        _products.add(info);
        removeInfoObject(info);
      } else {
        status = false;
      }
    }
    toggleSelectMode();
    return status;
  }

  void changeSelectedProductsToValue() {
    List<ReceiptObjectModel> selectedProducts = _selectedObjects
        .where((index) => productIndexExists(index))
        .map((index) => _products[index])
        .toList();

    for (ReceiptObjectModel product in selectedProducts) {
      _allValues.insertValue(product.text);
      removeProductObject(product);
    }
    toggleSelectMode();
  }

  void changeSelectedProductsToInfo() {
    List<ReceiptObjectModel> selectedProducts = _selectedObjects
        .where((index) => productIndexExists(index))
        .map((index) => _products[index])
        .toList();

    for (ReceiptObjectModel product in selectedProducts) {
      product.type = ReceiptObjectModelType.infoDouble;
      _infos.add(product);
      removeProductObject(product);
    }
    toggleSelectMode();
  }
}
