import 'package:save_receipt/data/models/document.dart';
import 'package:save_receipt/data/models/database_entities.dart';
import 'package:save_receipt/domain/entities/receipt.dart';
import 'package:save_receipt/services/values/patterns.dart';

class ReceiptDataConverter {
  static ReceiptData toReceiptData(ReceiptModel receipt, {int? shopId}) {
    List<ReceiptObjectModel> time = receipt.time;
    String timeStr = '';

    if (time.isNotEmpty) {
      timeStr = time[0].value ?? '';
    }
    return ReceiptData(
        id: receipt.receiptId,
        title: receipt.title,
        shopId: shopId,
        totalCost: 0.0,
        imgPath: receipt.imgPath,
        time: timeStr);
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
    List<ReceiptObjectModel> time = model.time;
    List<ProductData> products =
        model.products.map((e) => toProductData(e, receiptId)).toList();
    List<InfoData> infoTexts =
        model.infos.map((e) => toInfoData(e, receiptId)).toList();
    ReceiptData receipt = ReceiptData(
        id: model.receiptId,
        title: model.title,
        shopId: -1,
        totalCost: 0.0,
        imgPath: model.imgPath,
        time: time.isNotEmpty ? time[0].value ?? '' : '');
    return ReceiptDocumentData(
        receipt: receipt, infos: infoTexts, products: products, shop: shop);
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
      );

  static ReceiptObjectModel infoToReceiptObjectModel(InfoData info) =>
      ReceiptObjectModel(
        type: getInfoModelTypeBasedOnValue(info.value),
        dataId: info.id,
        text: info.name,
        value: info.value.isEmpty ? null : info.value,
      );

  static ReceiptObjectModelType getInfoModelTypeBasedOnValue(String value) {
    if (isPrice(value)) {
      return ReceiptObjectModelType.infoDouble;
    }
    if (isTime(value)) {
      return ReceiptObjectModelType.infoTime;
    }
    if (isNumeric(value)) {
      return ReceiptObjectModelType.infoNumeric;
    }
    return ReceiptObjectModelType.infoText;
  }

  static ReceiptModel toReceiptModel(ReceiptDocumentData data) {
    List<ReceiptObjectModel> objects =
        data.products.map((prod) => productToReceiptObjectModel(prod)).toList();
    objects +=
        data.infos.map((info) => infoToReceiptObjectModel(info)).toList();
    return ReceiptModel(
        title: data.receipt.title,
        objects: objects,
        imgPath: data.receipt.imgPath,
        receiptId: data.receipt.id);
  }
}
