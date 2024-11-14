import 'package:save_receipt/source/data/structures/data_field.dart';
import 'package:save_receipt/source/data/structures/receipt.dart';

class AllReceiptValues {
  AllValuesModel model;

  AllReceiptValues(
      {required List<String> priceValues,
      required List<String> infoValues,
      required List<String> dateValues})
      : model = AllValuesModel(
            prices: priceValues, info: infoValues, dates: dateValues);

  AllReceiptValues.fromReceipt(Receipt receipt)
      : this(
          priceValues: receipt.pricesStr,
          dateValues: receipt.datesStr,
          infoValues: receipt.infoStr,
        );

  void insertValue(String value) {
    if (isPrice(value)) {
      model.prices.add(value);
    } else if (isDate(value)) {
      model.dates.add(value);
    } else {
      model.info.add(value);
    }
  }
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
  RegExp regex =
      RegExp(r'([0-9]+:[0-9]+)+|[ \t]*([0-9]+[\-\\/][0-9]+[\-\\/][0-9]+)');
  return regex.hasMatch(data);
}

double parsePrice(String data) {
  return 0.0;
}
