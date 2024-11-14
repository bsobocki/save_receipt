import 'dart:core';
import 'package:save_receipt/source/data/structures/connected_data.dart';
import 'package:save_receipt/source/data/structures/receipt.dart';
import 'package:save_receipt/source/data/values.dart';

List<ReceiptObject> parseData(List<ConnectedTextLines> lines) {
  List<ReceiptObject> data = [];

  for (ConnectedTextLines line in lines) {
    bool isTwoPart = line.connectedLine != null;
    String text = line.start.text;

    if (isTwoPart) {
      String connectedStr = line.connectedLine!.text;
      if (isPrice(connectedStr)) {
        String priceStr = getPriceStr(connectedStr);
        double price = double.tryParse(priceStr) ?? -1.0;
        if (price != -1.0) {
          data.add(ReceiptProduct(text: text, price: price));
        } else {
          text += connectedStr;
          isTwoPart = false;
        }
      } else if (isDate(connectedStr)) {
        data.add(ReceiptDate(text: text, date: connectedStr));
      } else {
        data.add(ReceiptInfo(text: text, info: connectedStr));
      }
    }

    if (!isTwoPart) {
      data.add(ReceiptObject(text: text));
    }
  }
  return data;
}
