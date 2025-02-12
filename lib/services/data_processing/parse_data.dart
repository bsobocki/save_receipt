import 'dart:core';
import 'package:save_receipt/domain/entities/all_values.dart';
import 'package:save_receipt/domain/entities/connected_data.dart';
import 'package:save_receipt/domain/entities/receipt_object.dart';
import 'package:save_receipt/services/values/patterns.dart';

class ProcessedDataModel {
  List<ReceiptObjectModel> receiptObjectModels = [];
  AllValuesModel allValuesModel;

  ProcessedDataModel(
      {required this.receiptObjectModels, required this.allValuesModel});
}

class DataParser {
  late ProcessedDataModel _processedDataModel;

  DataParser.parseData(List<ConnectedTextLines> lines) {
    List<ReceiptObjectModel> receiptObjectModels = [];
    List<String> prices = [];
    List<String> info = [];
    List<String> dates = [];

    for (ConnectedTextLines line in lines) {
      bool isTwoPart = line.connectedLine != null;
      String text = line.start.text;

      if (isTwoPart) {
        String connectedStr = line.connectedLine!.text;
        if (hasPrice(connectedStr)) {
          String priceStr = getAllPricesFromStr(connectedStr).last;
          receiptObjectModels.add(
            ReceiptObjectModel(
                text: getProductTextWithoutPrice(text),
                value: priceStr,
                type: ReceiptObjectModelType.product),
          );
          prices.add(priceStr);
        } else if (isDate(connectedStr)) {
          receiptObjectModels.add(
            ReceiptObjectModel(
                text: text,
                value: connectedStr,
                type: ReceiptObjectModelType.infoDate),
          );
          dates.add(connectedStr);
        } else {
          receiptObjectModels.add(
            ReceiptObjectModel(
                text: text,
                value: connectedStr,
                type: ReceiptObjectModelType.infoText),
          );
          info.add(connectedStr);
        }
      } else {
        if (isProductWithPrice(text)) {
          receiptObjectModels.add(
            ReceiptObjectModel(
              text: getProductTextWithoutPrice(text),
              value: getAllPricesFromStr(text).last,
              type: ReceiptObjectModelType.product,
            ),
          );
          prices.add(getAllPricesFromStr(text).last);
        }
        else if (isPrice(text)) {
          prices.add(getAllPricesFromStr(text).last);
        } else if (isDate(text)) {
          receiptObjectModels.add(
            ReceiptObjectModel(
              text: 'DATE',
              value: text,
              type: ReceiptObjectModelType.infoDate,
            ),
          );
        } else {
          receiptObjectModels.add(
            ReceiptObjectModel(
              text: text,
              type: ReceiptObjectModelType.infoText,
            ),
          );
        }
      }
    }
    _processedDataModel = ProcessedDataModel(
      receiptObjectModels: receiptObjectModels,
      allValuesModel: AllValuesModel(
        prices: prices,
        info: info,
        dates: dates,
      ),
    );
  }

  ProcessedDataModel get processedDataModel => _processedDataModel;
}
