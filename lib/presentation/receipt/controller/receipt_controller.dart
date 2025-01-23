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
  List<ReceiptObjectModel> _infos = [];
  List<ReceiptObjectModel> _products = [];
  List<ReceiptObjectModel> _dates = [];
  final List<int> _deletedProductsIds = [];
  final List<int> _deletedInfoTextIds = [];
  final List<int> _deletedInfoDateIds = [];
  final List<int> _deletedInfoDoubleIds = [];
  final List<int> _deletedInfoNumericIds = [];
  int? receiptId;

  ReceiptModelController(
      final ReceiptModel receipt, AllValuesModel? allValuesModel) {
    _receiptImagePath = receipt.imgPath;
    _allValues = allValuesModel != null
        ? AllReceiptValuesController(model: allValuesModel)
        : AllReceiptValuesController.fromReceipt(receipt);
    _products = receipt.products;
    _infos = receipt.infos;
    _dates = receipt.dates;
    receiptId = receipt.receiptId;
  }

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
    // existing object insertion will work similar to update
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

    return receiptId;
  }

  Future<void> deleteReceipt(int receiptId) async {
    await ReceiptDatabaseRepository.get.deleteReceipt(receiptId);
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

  void changeInfoToProduct(int index) {
    if (infoIndexExists(index)) {
      toggleEditModeOfInfo(index);
      _products.add(_infos[index]);
      removeInfo(index);
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
      _infos[index].value = null;
    }
  }

  void changeInfoValueType(ReceiptObjectModelType newType, int index) {
    if (infoIndexExists(index)) {
      print("I AM CHANGING IT BABYYY!!!!");
      ReceiptObjectModelType oldType = _infos[index].type;
      _infos[index].type = newType;
      int? id = _infos[index].dataId;

      if (newType == ReceiptObjectModelType.product) {
        toggleEditModeOfInfo(index);
        _products.add(_infos[index]);
        _infos.removeAt(index);
      }

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
    }
  }

  void changeProductToInfoDouble(int index) {
    if (productIndexExists(index)) {
      toggleEditModeOfProduct(index);
      _products[index].type = ReceiptObjectModelType.infoDouble;
      _infos.add(_products[index]);
      removeProduct(index);
    }
  }

  void changeInfoDoubleToProduct(int index) {
    if (infoIndexExists(index)) {
      toggleEditModeOfInfo(index);
      _infos[index].type = ReceiptObjectModelType.product;
      _products.add(_infos[index]);
      removeInfo(index);
    }
  }

  void toggleEditModeOfInfo(int index) {
    if (infoIndexExists(index)) {
      _infos[index].isEditing = !_infos[index].isEditing;
    }
  }

  void toggleEditModeOfProduct(int index) {
    if (productIndexExists(index)) {
      _products[index].isEditing = !_products[index].isEditing;
    }
  }

  void removeInfo(int index) {
    if (infoIndexExists(index)) {
      int? id = _infos[index].dataId;
      if (id != null) {
        switch (_infos[index].type) {
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
      _infos.removeAt(index);
    }
  }

  void removeProduct(int index) {
    if (productIndexExists(index)) {
      int? id = _products[index].dataId;
      if (id != null) {
        _deletedProductsIds.add(id);
      }
      _products.removeAt(index);
    }
  }

  AllValuesModel get allValuesModel => _allValues.model;

  String? get imgPath => _receiptImagePath;

  List<ReceiptObjectModel> get objects => [
        ..._products,
        ..._infos,
      ];

  ReceiptModel get model => ReceiptModel(
      receiptId: receiptId, objects: objects, imgPath: _receiptImagePath);

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
}
