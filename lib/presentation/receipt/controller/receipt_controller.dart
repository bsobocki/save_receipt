import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:save_receipt/data/converters/data_converter.dart';
import 'package:save_receipt/data/models/document.dart';
import 'package:save_receipt/data/models/entities/info.dart';
import 'package:save_receipt/data/models/entities/product.dart';
import 'package:save_receipt/data/models/entities/receipt.dart';
import 'package:save_receipt/data/repositories/database_repository.dart';
import 'package:save_receipt/domain/entities/all_values.dart';
import 'package:save_receipt/domain/entities/receipt.dart';
import 'package:save_receipt/data/controller/values_controller.dart';

class ReceiptModelController {
  String? _receiptImagePath;
  late AllReceiptValuesController _allValues;
  final SplayTreeSet<int> _selectedObjectsIndexes =
      SplayTreeSet((a, b) => b.compareTo(a));
  List<ReceiptObjectModel> _infos = [];
  List<ReceiptObjectModel> _products = [];
  List<ReceiptObjectModel> _time = [];
  final List<int> _deletedProductsIds = [];
  final List<int> _deletedInfoTextIds = [];
  final List<int> _deletedInfoTimeIds = [];
  final List<int> _deletedInfoDoubleIds = [];
  final List<int> _deletedInfoNumericIds = [];
  final ValueNotifier<bool> _dataChangedNotifier = ValueNotifier<bool>(false);
  bool _areProductsEdited = true;
  bool _isSelectModeEnabled = false;
  int _editingObjectFieldIndex = -1;
  late String receiptTitle;
  int? _receiptId;

  ReceiptModelController({
    required final ReceiptModel receipt,
    AllValuesModel? allValuesModel,
  }) {
    receiptTitle = receipt.title;
    _receiptImagePath = receipt.imgPath;
    _allValues = allValuesModel != null
        ? AllReceiptValuesController(model: allValuesModel)
        : AllReceiptValuesController.fromReceipt(receipt);
    _products = receipt.products;
    _infos = receipt.infos;
    _time = receipt.time;
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
    for (int id in _deletedInfoTimeIds) {
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

  void changeObjectToValue(int index) {
    if (objectIndexExists(index)) {
      ReceiptObjectModel obj = objectAt(index);
      _allValues.insertValue(obj.text);
      removeObject(obj);
    }
  }

  void changeValueToInfo(int index) {
    if (infoIndexExists(index) && infoHasValue(index)) {
      _allValues.removeValue(_infos[index].value!);
      String newTextFromValue = _infos[index].value!;
      _infos[index].value = null;
      _infos.add(
        ReceiptObjectModel(
          type: ReceiptObjectModelType.infoText,
          text: newTextFromValue,
          value: null,
        ),
      );
      trackChange();
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
          case ReceiptObjectModelType.infoTime:
            _deletedInfoTimeIds.add(id);
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
      _infos.add(
        ReceiptObjectModel.newObjectFrom(
          _products[index],
          type: ReceiptObjectModelType.infoDouble,
        ),
      );
      removeObjectByIndex(index);
    }
  }

  bool changeInfoDoubleToProduct(int index) {
    if (infoIndexExists(index)) {
      if (_infos[index].value == null) {
        return false;
      }
      var infoObj = _infos[index];
      _products.add(
        ReceiptObjectModel.newObjectFrom(
          infoObj,
          type: ReceiptObjectModelType.product,
        ),
      );
      removeObjectByIndex(index);
    }
    return true;
  }

  void addEmptyObject() {
    if (_areProductsEdited) {
      _products.add(
        ReceiptObjectModel(
          type: ReceiptObjectModelType.product,
          text: "<new-product>",
          value: "0.0",
        ),
      );
    } else {
      _infos.add(
        ReceiptObjectModel(
          type: ReceiptObjectModelType.infoText,
          text: "<new-info-text>",
        ),
      );
    }
    trackChange();
  }

  void removeObjectByIndex(int index) {
    if (objectIndexExists(index)) {
      if (_editingObjectFieldIndex == index) {
        resetEditModeIndex();
      }
      removeObject(objectAt(index));
    }
  }

  void removeObject(ReceiptObjectModel object) {
    int? id = object.dataId;
    if (id != null) {
      switch (object.type) {
        case ReceiptObjectModelType.infoText:
          _deletedInfoTextIds.add(id);
          break;
        case ReceiptObjectModelType.infoDouble:
          _deletedInfoDoubleIds.add(id);
          break;
        case ReceiptObjectModelType.infoNumeric:
          _deletedInfoNumericIds.add(id);
          break;
        case ReceiptObjectModelType.infoTime:
          _deletedInfoTimeIds.add(id);
          break;
        case ReceiptObjectModelType.product:
          _deletedProductsIds.add(id);
        default:
          break;
      }
    }
    if (_areProductsEdited) {
      _products.remove(object);
    } else {
      _infos.remove(object);
    }
    trackChange();
  }

  void setProductsEditing() {
    _areProductsEdited = true;
    resetEditModeIndex();
    _selectedObjectsIndexes.clear();
  }

  void setInfoEditing() {
    _areProductsEdited = false;
    resetEditModeIndex();
    _selectedObjectsIndexes.clear();
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
    _selectedObjectsIndexes.clear();
  }

  void toggleObjectSelection(int index) {
    if (isObjectSelected(index)) {
      unselectObject(index);
    } else {
      selectObject(index);
    }
  }

  void selectObject(int index) {
    if (objectIndexExists(index)) {
      _selectedObjectsIndexes.add(index);
    }
  }

  void unselectObject(int index) {
    if (objectIndexExists(index)) {
      _selectedObjectsIndexes.remove(index);
    }
  }

  AllValuesModel get allValuesModel => _allValues.model;

  String? get imgPath => _receiptImagePath;

  List<ReceiptObjectModel> get objects => [
        ..._products,
        ..._infos,
      ];

  ReceiptModel get model => ReceiptModel(
        title: receiptTitle,
        receiptId: _receiptId,
        objects: objects,
        imgPath: _receiptImagePath,
      );

  List<ReceiptObjectModel> get products => _products;

  List<ReceiptObjectModel> get infos => _infos;

  List<ReceiptObjectModel> get times => _time;

  List<ReceiptObjectModel> get currentObjectList =>
      _areProductsEdited ? _products : _infos;

  bool productIndexExists(int index) => index >= 0 && index < _products.length;

  bool infoIndexExists(int index) => index >= 0 && index < _infos.length;

  bool objectIndexExists(int index) =>
      _areProductsEdited ? productIndexExists(index) : infoIndexExists(index);

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

  ReceiptObjectModel objectAt(int index) =>
      _areProductsEdited ? _products[index] : _infos[index];

  bool isObjectInEditMode(int index) =>
      objectIndexExists(index) && index == _editingObjectFieldIndex;

  bool isProductInEditMode(int index) =>
      _areProductsEdited && isObjectInEditMode(index);

  bool isInfoInEditMode(int index) =>
      !_areProductsEdited && isObjectInEditMode(index);

  bool isObjectSelected(int index) =>
      objectIndexExists(index) && _selectedObjectsIndexes.contains(index);

  bool isProductSelected(int index) =>
      _areProductsEdited && isObjectSelected(index);

  bool isInfoSelected(int index) =>
      !_areProductsEdited && isObjectSelected(index);

  List<ReceiptObjectModel> get selectedObjects => _selectedObjectsIndexes
      .where((index) => objectIndexExists(index))
      .map((index) => objectAt(index))
      .toList();

  void removeSelectedObjects() {
    for (int index in _selectedObjectsIndexes) {
      removeObjectByIndex(index);
    }
    toggleSelectMode();
  }

  void changeSelectedInfoValueType(ReceiptObjectModelType type) {
    for (int index in _selectedObjectsIndexes) {
      changeInfoValueType(type, index);
    }
    toggleSelectMode();
  }

  void changeSelectedObjectsToValue() {
    for (ReceiptObjectModel obj in selectedObjects) {
      _allValues.insertValue(obj.text);
      removeObject(obj);
    }
    toggleSelectMode();
  }

  bool changeSelectedObjectsToProducts() {
    bool status = true;
    for (ReceiptObjectModel obj in selectedObjects) {
      if (obj.value != null && obj.type == ReceiptObjectModelType.infoDouble) {
        removeObject(obj);
        _products.add(
          ReceiptObjectModel.newObjectFrom(
            obj,
            type: ReceiptObjectModelType.product,
          ),
        );
      } else {
        status = false;
      }
    }
    toggleSelectMode();
    return status;
  }

  void changeSelectedProductsToInfo() {
    for (ReceiptObjectModel obj in selectedObjects) {
      removeObject(obj);
      _infos.add(
        ReceiptObjectModel.newObjectFrom(
          obj,
          type: ReceiptObjectModelType.infoDouble,
        ),
      );
    }
    toggleSelectMode();
  }
}
