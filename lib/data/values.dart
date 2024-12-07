import 'package:save_receipt/domain/entities/all_values.dart';
import 'package:save_receipt/domain/entities/receipt.dart';

class AllReceiptValuesController {
  AllValuesModel model;

  AllReceiptValuesController(
      {required List<double> priceValues,
      required List<String> infoValues,
      required List<String> dateValues})
      : model = AllValuesModel(
            prices: priceValues, info: infoValues, dates: dateValues);

  AllReceiptValuesController.fromReceipt(ReceiptModel receipt)
      : this(
          priceValues: receipt.prices,
          dateValues: receipt.datesStr,
          infoValues: receipt.infoStr,
        );

  void insertValue(String value) {
    if (isPrice(value)) {
      model.prices.add(double.tryParse(value) ?? 0.0);
    } else if (isDate(value)) {
      model.dates.add(value);
    } else {
      model.info.add(value);
    }
  }

  void removeValue(String value) {
    if (isPrice(value)) {
      model.prices.remove(double.tryParse(value));
    } else if (isDate(value)) {
      model.dates.remove(value);
    } else {
      model.info.remove(value);
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
