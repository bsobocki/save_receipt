import 'package:save_receipt/data/models/document.dart';
import 'package:save_receipt/data/models/database_entities.dart';
import 'package:save_receipt/domain/entities/receipt.dart';

class ReceiptDataConverter {
  static ReceiptData toReceiptData(ReceiptModel receipt, {int? shopId}) {
    List<ReceiptObjectModel> dates = receipt.dates;
    String date = '';

    if (dates.isNotEmpty) {
      date = dates[0].value ?? '';
    }
    return ReceiptData(
        id: receipt.receiptId,
        shopId: shopId,
        totalCost: 0.0,
        imgPath: receipt.imgPath,
        date: date);
  }

  static ProductData toProductData(ReceiptObjectModel product, int receiptId) {
    double? price;
    if (product.value != null) {
      price = double.tryParse(product.value!);
    }
    return ProductData(
        id: product.dataId,
        name: product.text,
        price: price ?? -1.0,
        receiptId: receiptId);
  }

  static InfoData toInfoData(ReceiptObjectModel info, int receiptId) {
    return InfoData(
        id: info.dataId,
        name: info.text,
        value: info.value ?? '',
        receiptId: receiptId);
  }

  static ReceiptDocumentData toDocumentData(ReceiptModel model, int receiptId) {
    ShopData? shop; // for now shops are not supported
    List<ReceiptObjectModel> dates = model.dates;
    List<ProductData> products =
        model.productObjs.map((e) => toProductData(e, receiptId)).toList();
    List<InfoData> infos = model.infoStrObjs
        .map((e) => ReceiptDataConverter.toInfoData(e, receiptId))
        .toList();
    ReceiptData receipt = ReceiptData(
        id: model.receiptId,
        shopId: -1,
        totalCost: 0.0,
        imgPath: model.imgPath,
        date: dates.isNotEmpty ? dates[0].value ?? '' : '');
    return ReceiptDocumentData(
        receipt: receipt, infos: infos, products: products, shop: shop);
  }

  static ReceiptDocumentData toDocumentDataForExistingReceipt(
      ReceiptModel model) {
    return toDocumentData(model, model.receiptId!);
  }

  static ReceiptObjectModel productToReceiptObjectModel(ProductData prod) =>
      ReceiptObjectModel(
        type: ReceiptObjectModelType.product,
        dataId: prod.id,
        text: prod.name,
        value: prod.price.toString(),
        isEditing: false,
      );

  static ReceiptObjectModel infoToReceiptObjectModel(InfoData info) =>
      ReceiptObjectModel(
        type: ReceiptObjectModelType.infoText,
        dataId: info.id,
        text: info.name,
        value: info.value.isEmpty ? null : info.value,
        isEditing: false,
      );

  static ReceiptModel toReceiptModel(ReceiptDocumentData data) {
    List<ReceiptObjectModel> objects =
        data.products.map((prod) => productToReceiptObjectModel(prod)).toList();
    objects +=
        data.infos.map((info) => infoToReceiptObjectModel(info)).toList();
    return ReceiptModel(
        objects: objects,
        imgPath: data.receipt.imgPath,
        receiptId: data.receipt.id);
  }
}
