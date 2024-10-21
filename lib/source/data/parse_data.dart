import 'dart:core';
import 'package:save_receipt/source/data/structures/connected_data.dart';
import 'package:save_receipt/source/data/structures/receipt.dart';

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
          data.add(Product(text: text, price: price));
        } else {
          text += connectedStr;
          isTwoPart = false;
        }
      } 
      else if (isDate(connectedStr)) {
        data.add(Date(text: text, date: connectedStr));
      }
      else {
        data.add(TwoPartInfo(text: text, info: connectedStr));
      }
    }

    if (!isTwoPart) {
      data.add(ReceiptObject(text: text));
    }
  }
  return data;
}

bool isNumeric(String data) {
  return false;
}

bool isPrice(String data) {
  RegExp regex = RegExp(r'[0-9]+[,\.][0-9]+[a-zA-Z]*');
  return regex.hasMatch(data);
}

String getPriceStr(String data) {
  RegExp regex = RegExp(r'([0-9]+[,\.]*[0-9]+)');
  return regex.firstMatch(data)?[0]?.replaceAll(RegExp(','), '.') ?? '';
}

bool isDate(String data) {
  RegExp regex = RegExp(r'([0-9]+:[0-9]+)+|[ \t]*([0-9]+[\-\\/][0-9]+[\-\\/][0-9]+)');
  return regex.hasMatch(data);
}

double parsePrice(String data) {
  return 0.0;
}
