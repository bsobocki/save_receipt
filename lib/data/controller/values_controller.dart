import 'package:save_receipt/domain/entities/all_values.dart';
import 'package:save_receipt/domain/entities/receipt.dart';
import 'package:save_receipt/services/values/patterns.dart';

class AllReceiptValuesController {
  AllValuesModel model;

  AllReceiptValuesController.fromValues(
      {required List<String> priceValues,
      required List<String> infoValues,
      required List<String> timeValues})
      : model = AllValuesModel(
            prices: priceValues, info: infoValues, time: timeValues);

  AllReceiptValuesController({required this.model});

  AllReceiptValuesController.fromReceipt(ReceiptModel receipt)
      : model = AllValuesModel(
            prices: receipt.prices,
            info: receipt.infoStr,
            time: receipt.timeStr);

  void insertValue(String value) {
    if (isPrice(value)) {
      model.prices.add(value);
    } else if (isTime(value)) {
      model.time.add(value);
    } else {
      model.info.add(value);
    }
  }

  void removeValue(String value) {
    if (isPrice(value)) {
      model.prices.remove(value);
    } else if (isTime(value)) {
      model.time.remove(value);
    } else {
      model.info.remove(value);
    }
  }
}
