import 'dart:core';
import 'package:save_receipt/source/data/structures/connected_data.dart';
import 'package:save_receipt/source/data/structures/receipt.dart';
import 'package:save_receipt/source/data/values.dart';

List<ReceiptModelObject> parseData(List<ConnectedTextLines> lines) {
  List<ReceiptModelObject> data = [];

  for (ConnectedTextLines line in lines) {
    bool isTwoPart = line.connectedLine != null;
    String text = line.start.text;

    if (isTwoPart) {
      String connectedStr = line.connectedLine!.text;
      if (isPrice(connectedStr)) {
        String priceStr = getPriceStr(connectedStr);
        double price = double.tryParse(priceStr) ?? -1.0;
        if (price != -1.0) {
          data.add(ReceiptModelProduct(text: text, price: price));
        } else {
          text += connectedStr;
          isTwoPart = false;
        }
      } else if (isDate(connectedStr)) {
        data.add(ReceiptModelDate(text: text, date: connectedStr));
      } else {
        data.add(ReceiptModelInfo(text: text, info: connectedStr));
      }
    }

    if (!isTwoPart) {
      data.add(ReceiptModelObject(text: text));
    }
  }
  return data;
}
