import 'dart:core';
import 'package:save_receipt/domain/entities/connected_data.dart';
import 'package:save_receipt/data/values.dart';
import 'package:save_receipt/domain/entities/receipt_object.dart';

List<ReceiptObjectModel> parseData(List<ConnectedTextLines> lines) {
  List<ReceiptObjectModel> data = [];

  for (ConnectedTextLines line in lines) {
    bool isTwoPart = line.connectedLine != null;
    String text = line.start.text;

    if (isTwoPart) {
      String connectedStr = line.connectedLine!.text;
      if (isPrice(connectedStr)) {
        String priceStr = getPriceStr(connectedStr);
        data.add(ReceiptObjectModel(
            text: text, value: priceStr, type: ReceiptObjectModelType.product));
      } else if (isDate(connectedStr)) {
        data.add(ReceiptObjectModel(
            text: text,
            value: connectedStr,
            type: ReceiptObjectModelType.infoDate));
      } else {
        data.add(ReceiptObjectModel(
            text: text,
            value: connectedStr,
            type: ReceiptObjectModelType.infoText));
      }
    }

    if (!isTwoPart) {
      data.add(
          ReceiptObjectModel(text: text, type: ReceiptObjectModelType.infoText));
    }
  }
  return data;
}
