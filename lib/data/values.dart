import 'package:save_receipt/domain/entities/all_values.dart';
import 'package:save_receipt/domain/entities/receipt.dart';
import 'package:save_receipt/services/values/patterns.dart';

class AllReceiptValuesController {
  AllValuesModel model;

  AllReceiptValuesController.fromValues(
      {required List<String> priceValues,
      required List<String> infoValues,
      required List<String> dateValues})
      : model = AllValuesModel(
            prices: priceValues, info: infoValues, dates: dateValues);

  AllReceiptValuesController({required this.model});

  AllReceiptValuesController.fromReceipt(ReceiptModel receipt)
      : model = AllValuesModel(
            prices: receipt.prices,
            info: receipt.infoStr,
            dates: receipt.datesStr);

  void insertValue(String value) {
    if (isPrice(value)) {
      model.prices.add(value);
    } else if (isDate(value)) {
      model.dates.add(value);
    } else {
      model.info.add(value);
    }
  }

  void removeValue(String value) {
    if (isPrice(value)) {
      model.prices.remove(value);
    } else if (isDate(value)) {
      model.dates.remove(value);
    } else {
      model.info.remove(value);
    }
  }
}
